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
  double? _distance;
  double? _duration;
  bool _loading = true;
  String? _error;

  // Pending bounds fit — applied after the map renders for the first time.
  List<LatLng>? _pendingFitPoints;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final granted = await Geolocator.requestPermission();
        if (granted == LocationPermission.denied ||
            granted == LocationPermission.deniedForever) {
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
      final driverLoc = LatLng(position.latitude, position.longitude);

      final from = widget.params.mode == MapMode.toStore
          ? driverLoc
          : LatLng(widget.params.storeLat, widget.params.storeLng);
      final to = widget.params.mode == MapMode.toStore
          ? LatLng(widget.params.storeLat, widget.params.storeLng)
          : LatLng(widget.params.userLat, widget.params.userLng);

      List<LatLng> routePoints = [from, to]; // straight-line fallback
      double? distance;
      double? duration;

      try {
        final dio = Dio();
        final response = await dio
            .get(
              'https://router.project-osrm.org/route/v1/driving/'
              '${from.longitude},${from.latitude};${to.longitude},${to.latitude}',
              queryParameters: {'geometries': 'geojson', 'overview': 'full'},
            )
            .timeout(const Duration(seconds: 8));

        final data = response.data;
        final route = data['routes'][0];
        final coords = route['geometry']['coordinates'] as List;
        routePoints = coords
            .map((c) => LatLng(c[1] as double, c[0] as double))
            .toList();
        distance = (route['distance'] as num).toDouble();
        duration = (route['duration'] as num).toDouble();
      } catch (_) {
        // OSRM unavailable — keep straight-line fallback
      }

      final allPoints = [
        driverLoc,
        LatLng(widget.params.storeLat, widget.params.storeLng),
        LatLng(widget.params.userLat, widget.params.userLng),
        ...routePoints,
      ];

      setState(() {
        _driverLocation = driverLoc;
        _routePoints = routePoints;
        _distance = distance;
        _duration = duration;
        _loading = false;
        _pendingFitPoints = allPoints;
      });

      // If the map is already ready, fit immediately; otherwise it will be
      // applied in onMapReady (called after the first frame).
      if (_mapReady) _fitBounds(allPoints);
    } catch (e) {
      setState(() {
        _error = 'Could not get your location: ${e.toString()}';
        _loading = false;
      });
    }
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
    return Scaffold(
      body: Stack(
        children: [
          if (_driverLocation != null)
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _driverLocation!,
                initialZoom: 13,
                // Called once the map widget is fully rendered and the
                // MapController is ready to accept commands.
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
                  // Required by OSM tile usage policy to avoid 403 blocks.
                  userAgentPackageName: 'com.elevate.trackingapp',
                ),
                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        color: AppColors.primary,
                        strokeWidth: 4,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _driverLocation!,
                      child: const MapMarker(
                        svgAsset: 'assets/svgs/my_location.svg',
                        width: 90,
                        height: 20,
                        alignment: Alignment.center,
                      ),
                    ),
                    Marker(
                      point: LatLng(
                        widget.params.storeLat,
                        widget.params.storeLng,
                      ),
                      child: const MapMarker(
                        svgAsset: 'assets/svgs/flowery_location.svg',
                        width: 56,
                        height: 20,
                        alignment: Alignment.center,
                      ),
                    ),
                    Marker(
                      point: LatLng(
                        widget.params.userLat,
                        widget.params.userLng,
                      ),
                      child: const MapMarker(
                        svgAsset: 'assets/svgs/user_location.svg',
                        width: 44,
                        height: 24,
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
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.error),
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
                distance: _distance,
                duration: _duration,
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
