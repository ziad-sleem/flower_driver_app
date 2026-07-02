import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class GeocodingHelper {
  static final Dio _dio = Dio();

  static Future<LatLng?> geocodeAddress(String address) async {
    if (address.isEmpty) return null;
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': address,
          'format': 'json',
          'limit': 1,
        },
        options: Options(
          headers: {'User-Agent': 'TrackingApp/1.0'},
        ),
      );
      final data = response.data;
      if (data is List && data.isNotEmpty) {
        final lat = double.tryParse(data[0]['lat']?.toString() ?? '');
        final lon = double.tryParse(data[0]['lon']?.toString() ?? '');
        if (lat != null && lon != null) return LatLng(lat, lon);
      }
    } catch (_) {}
    return null;
  }
}
