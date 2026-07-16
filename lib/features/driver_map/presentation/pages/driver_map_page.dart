import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/features/driver_map/domain/entities/driver_map_params.dart';
import 'package:tracking_app/features/driver_map/presentation/widgets/map_bottom_sheet.dart';
import 'package:tracking_app/features/driver_map/presentation/widgets/map_marker.dart';

class DriverMapPage extends StatefulWidget {
  final DriverMapParams params;

  const DriverMapPage({super.key, required this.params});

  @override
  State<DriverMapPage> createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage> {
  final MapController _mapController = MapController();
  LatLng? _driverLocation;
  List<LatLng> _routePoints = [];
  double? _routeDistance;
  double? _routeDuration;
  bool _loading = true;
  String? _error;

  List<LatLng>? _pendingFitPoints;
  bool _mapReady = false;

  StreamSubscription<Position>? _positionSubscription;

  bool get _isToStore => widget.params.mode == MapMode.toStore;

  LatLng? get _destinationPoint {
    if (_isToStore) {
      final lat = widget.params.storeLat;
      final lng = widget.params.storeLng;
      return (lat != null && lng != null) ? LatLng(lat, lng) : null;
    } else {
      final lat = widget.params.userLat;
      final lng = widget.params.userLng;
      return (lat != null && lng != null) ? LatLng(lat, lng) : null;
    }
  }

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initMap() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error =
              'Location services are disabled. Please enable them in Settings.';
          _loading = false;
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error =
                'Location permission denied. Please enable it in Settings.';
            _loading = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error =
              'Location permission permanently denied. Please enable it in Settings.';
          _loading = false;
        });
        return;
      }

      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 30),
          ),
        );
      } on TimeoutException {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 30),
          ),
        );
      }
      final initialLoc = LatLng(position.latitude, position.longitude);

      await _updateRouteAndPosition(initialLoc, isInitial: true);

      _positionSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            ),
          ).listen(
            (Position newPosition) {
              final newLoc = LatLng(
                newPosition.latitude,
                newPosition.longitude,
              );
              _updateRouteAndPosition(newLoc, isInitial: false);
            },
            onError: (err) {
              debugPrint('Location stream error: $err');
            },
          );
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Could not get your location: ${e.toString()}';
          _loading = false;
        });
      }
    }
  }

  Future<void> _updateRouteAndPosition(
    LatLng driverLoc, {
    required bool isInitial,
  }) async {
    final dest = _destinationPoint;
    final result = dest != null ? await _fetchRoute(driverLoc, dest) : null;

    final allPoints = <LatLng>[
      driverLoc,
      ?dest,
      if (result != null) ...result.points,
    ];

    if (!mounted) return;

    setState(() {
      _driverLocation = driverLoc;
      _routePoints = result?.points ?? (dest != null ? [driverLoc, dest] : []);
      _routeDistance = result?.distance;
      _routeDuration = result?.duration;
      _loading = false;
      if (isInitial) {
        _pendingFitPoints = allPoints;
      }
    });

    if (isInitial && _mapReady) {
      _fitBounds(allPoints);
      _pendingFitPoints = null;
    }
  }

  Future<_RouteResult?> _fetchRoute(LatLng from, LatLng to) async {
    try {
      final dio = Dio();
      final response = await dio
          .get(
            'https://router.project-osrm.org/route/v1/driving/'
            '${from.longitude},${from.latitude};'
            '${to.longitude},${to.latitude}',
            queryParameters: {'geometries': 'geojson', 'overview': 'full'},
          )
          .timeout(const Duration(seconds: 15));
      final data = response.data;
      if (data != null &&
          data['routes'] != null &&
          (data['routes'] as List).isNotEmpty) {
        final route = data['routes'][0];
        final coords = route['geometry']['coordinates'] as List;
        final points = coords
            .map((c) => LatLng(c[1] as double, c[0] as double))
            .toList();
        return _RouteResult(
          points: points,
          distance: (route['distance'] as num).toDouble(),
          duration: (route['duration'] as num).toDouble(),
        );
      }
    } catch (_) {}
    return null;
  }

  void _fitBounds(List<LatLng> points) {
    if (points.length < 2) return;
    final bounds = LatLngBounds.fromPoints(points);
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dest = _destinationPoint;

    return Scaffold(
      body: Stack(
        children: [
          if (_driverLocation != null)
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _driverLocation!,
                initialZoom: 13,

                onMapReady: () {
                  _mapReady = true;
                  if (_pendingFitPoints != null) {
                    _fitBounds(_pendingFitPoints!);
                    _pendingFitPoints = null;
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.elevate.trackingapp',
                ),
                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        color: _isToStore
                            ? AppColors.primary
                            : const Color(0xFF2196F3),
                        strokeWidth: 4,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    // Driver marker — badge/pill shape, centred on geo point
                    Marker(
                      point: _driverLocation!,
                      width: mapMarkerDimensions(MapMarkerKind.driver).width,
                      height: mapMarkerDimensions(MapMarkerKind.driver).height,
                      alignment: mapMarkerDimensions(
                        MapMarkerKind.driver,
                      ).alignment,
                      child: const MapMarker(
                        kind: MapMarkerKind.driver,
                        showPulse: true,
                      ),
                    ),
                    if (dest != null) ...[
                      () {
                        final kind = _isToStore
                            ? MapMarkerKind.store
                            : MapMarkerKind.user;
                        final dims = mapMarkerDimensions(kind);
                        return Marker(
                          point: dest,
                          width: dims.width,
                          height: dims.height,
                          alignment: dims.alignment,
                          child: MapMarker(kind: kind),
                        );
                      }(),
                    ],
                  ],
                ),
              ],
            ),
          if (_loading)
            Container(
              color: AppColors.surface,
              child: const Center(child: CircularProgressIndicator()),
            ),
          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => Geolocator.openLocationSettings(),
                      icon: const Icon(Icons.settings),
                      label: const Text('Open Settings'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _error = null;
                          _loading = true;
                        });
                        _initMap();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          if (_driverLocation != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MapBottomSheet(
                params: widget.params,
                distance: _routeDistance,
                duration: _routeDuration,
                onDestinationTap: dest != null
                    ? () => _mapController.move(dest, 16)
                    : null,
              ),
            ),
          if (_driverLocation != null)
            Positioned(
              right: 16,
              bottom: 250 + MediaQuery.of(context).padding.bottom,
              child: FloatingActionButton(
                heroTag: 'recenter_fab',
                mini: true,
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.primary,
                onPressed: () {
                  if (_driverLocation != null) {
                    _mapController.move(_driverLocation!, 15);
                  }
                },
                child: const Icon(Icons.my_location),
              ),
            ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: CircleAvatar(
              backgroundColor: AppColors.surface,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteResult {
  final List<LatLng> points;
  final double distance;
  final double duration;

  const _RouteResult({
    required this.points,
    required this.distance,
    required this.duration,
  });
}
