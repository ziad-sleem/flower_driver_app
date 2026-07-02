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
  List<LatLng> _storeRoutePoints = [];
  List<LatLng> _userRoutePoints = [];
  double? _storeDistance;
  double? _storeDuration;
  double? _userDistance;
  double? _userDuration;
  bool _loading = true;
  String? _error;
  double _currentZoom = 13;

  // Pending bounds fit — applied after the map renders for the first time.
  List<LatLng>? _pendingFitPoints;
  bool _mapReady = false;

  StreamSubscription<Position>? _positionSubscription;

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

  double _markerScale(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenFactor = screenWidth / 400;
    final zoomFactor = _currentZoom / 13;
    return (screenFactor * zoomFactor).clamp(0.8, 1.2);
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

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      final initialLoc = LatLng(position.latitude, position.longitude);

      await _updateRouteAndPosition(initialLoc, isInitial: true);

      // Start listening to live location stream
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
    LatLng? storeLoc =
        widget.params.storeLat != null && widget.params.storeLng != null
        ? LatLng(widget.params.storeLat!, widget.params.storeLng!)
        : null;
    LatLng? userLoc =
        widget.params.userLat != null && widget.params.userLng != null
        ? LatLng(widget.params.userLat!, widget.params.userLng!)
        : null;

    final storeFuture = storeLoc != null
        ? _fetchRoute(driverLoc, storeLoc)
        : Future<_RouteResult?>.value(null);
    final userFuture = userLoc != null
        ? _fetchRoute(driverLoc, userLoc)
        : Future<_RouteResult?>.value(null);
    final results = await Future.wait<_RouteResult?>([storeFuture, userFuture]);
    final storeResult = results[0];
    final userResult = results[1];

    final allPoints = <LatLng>[
      driverLoc,
      if (storeLoc != null) storeLoc,
      if (userLoc != null) userLoc,
      if (storeResult != null) ...storeResult.points,
      if (userResult != null) ...userResult.points,
    ];

    if (!mounted) return;

    setState(() {
      _driverLocation = driverLoc;
      _storeRoutePoints =
          storeResult?.points ??
          (storeLoc != null ? [driverLoc, storeLoc] : []);
      _userRoutePoints =
          userResult?.points ?? (userLoc != null ? [driverLoc, userLoc] : []);
      _storeDistance = storeResult?.distance;
      _storeDuration = storeResult?.duration;
      _userDistance = userResult?.distance;
      _userDuration = userResult?.duration;
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
    final scale = _markerScale(context);

    return Scaffold(
      body: Stack(
        children: [
          if (_driverLocation != null)
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _driverLocation!,
                initialZoom: 13,
                onMapEvent: (event) {
                  if (event is MapEventMoveEnd) {
                    setState(() {
                      _currentZoom = event.camera.zoom;
                    });
                  }
                },
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
                if (_storeRoutePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _storeRoutePoints,
                        color: AppColors.primary,
                        strokeWidth: 4,
                      ),
                    ],
                  ),
                if (_userRoutePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _userRoutePoints,
                        color: const Color(0xFF2196F3),
                        strokeWidth: 4,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _driverLocation!,
                      alignment: Alignment.bottomCenter,
                      child: MapMarker(
                        kind: MapMarkerKind.driver,
                        size: 52 * scale,
                        showPulse: true,
                      ),
                    ),
                    if (widget.params.storeLat != null &&
                        widget.params.storeLng != null)
                      Marker(
                        point: LatLng(
                          widget.params.storeLat!,
                          widget.params.storeLng!,
                        ),
                        alignment: Alignment.bottomCenter,
                        child: MapMarker(
                          kind: MapMarkerKind.store,
                          size: 48 * scale,
                        ),
                      ),
                    if (widget.params.userLat != null &&
                        widget.params.userLng != null)
                      Marker(
                        point: LatLng(
                          widget.params.userLat!,
                          widget.params.userLng!,
                        ),
                        alignment: Alignment.bottomCenter,
                        child: MapMarker(
                          kind: MapMarkerKind.user,
                          size: 48 * scale,
                        ),
                      ),
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
                storeDistance: _storeDistance,
                storeDuration: _storeDuration,
                userDistance: _userDistance,
                userDuration: _userDuration,
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
