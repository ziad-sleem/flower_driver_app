class CountryModel {
  final String isoCode;
  final String name;
  final String phoneCode;
  final String flag;
  final String currency;
  final double latitude;
  final double longitude;

  const CountryModel({
    required this.isoCode,
    required this.name,
    required this.phoneCode,
    required this.flag,
    required this.currency,
    required this.latitude,
    required this.longitude,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      isoCode: json['isoCode'] ?? '',
      name: json['name'] ?? '',
      phoneCode: json['phoneCode'] ?? '',
      flag: json['flag'] ?? '',
      currency: json['currency'] ?? '',
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
    );
  }
}