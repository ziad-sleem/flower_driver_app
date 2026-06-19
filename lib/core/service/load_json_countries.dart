import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/data/models/country_model.dart';

@injectable
class CountryService {
  Future<List<CountryModel>> getCountries() async {
    final data = await rootBundle.loadString('assets/data/country.json');

    final List decoded = json.decode(data);

    return decoded.map((e) => CountryModel.fromJson(e)).toList();
  }
}
