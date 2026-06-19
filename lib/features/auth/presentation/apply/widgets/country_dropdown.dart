import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization_constants/delivery_application_constants.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/features/auth/data/models/country_model.dart';

class CountryDropdown extends StatelessWidget {
  final List<CountryModel> countries;
  final CountryModel? selectedCountry;
  final ValueChanged<CountryModel> onChanged;

  const CountryDropdown({
    super.key,
    required this.countries,
    required this.selectedCountry,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CountryModel>(
      initialValue: selectedCountry,
      icon: Icon(Icons.keyboard_arrow_down_outlined),
      decoration: InputDecoration(
        labelText: DeliveryApplicationConstants.country,
        hintText: DeliveryApplicationConstants.selectYourCountry,
      ),
      items: countries.map((country) {
        return DropdownMenuItem(
          value: country,
          child: Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Text(
                    '${country.flag}  ',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextSpan(
                  text: country.name,
                  style: getMediumStyle(
                    context: context,
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (country) {
        if (country != null) {
          onChanged(country);
        }
      },
    );
  }
}
