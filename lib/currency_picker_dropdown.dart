import 'package:currency_pickers/country.dart';
import 'package:currency_pickers/countries.dart';
import 'package:currency_pickers/utils/typedefs.dart';
import 'package:flutter/material.dart';
import 'utils/utils.dart';

///Provides a customizable [DropdownButton] for all countries
class CurrencyPickerDropdown extends StatefulWidget {
  CurrencyPickerDropdown({
    this.itemFilter,
    this.itemBuilder,
    this.initialValue,
    this.onValuePicked,
  });

  /// Filters the available country list
  final ItemFilter? itemFilter;

  ///This function will be called to build the child of DropdownMenuItem
  ///If it is not provided, default one will be used which displays
  ///flag image, isoCode and currencyCode in a row.
  ///Check _buildDefaultMenuItem method for details.
  final ItemBuilder? itemBuilder;

  ///It should be one of the ISO ALPHA-2 Code that is provided
  ///in countryList map of countries.dart file.
  final String? initialValue;

  ///This function will be called whenever a Country item is selected.
  final ValueChanged<Country?>? onValuePicked;

  @override
  _CurrencyPickerDropdownState createState() => _CurrencyPickerDropdownState();
}

class _CurrencyPickerDropdownState extends State<CurrencyPickerDropdown> {
  List<Country> _countries = [];
  Country? _selectedCountry;

  @override
  void initState() {
    _countries = countryList
        .where(widget.itemFilter ?? acceptAllCountries)
        .toList();

    if (widget.initialValue != null) {
      try {
        _selectedCountry = _countries.firstWhere(
          (country) => country.isoCode == widget.initialValue?.toUpperCase(),
        );
      } catch (error) {
        throw Exception(
            "The initialValue provided is not a supported iso code!");
      }
    } else {
      _selectedCountry = _countries[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<Country>> items = _countries
        .map((country) => DropdownMenuItem<Country>(
            value: country,
            child: widget.itemBuilder != null
                ? widget.itemBuilder?.call(country) ?? SizedBox()
                : _buildDefaultMenuItem(country)))
        .toList();

    return Row(
      children: <Widget>[
        DropdownButtonHideUnderline(
          child: DropdownButton<Country>(
            isDense: true,
            onChanged: (value) {
              setState(() {
                _selectedCountry = value;
                widget.onValuePicked?.call(value);
              });
            },
            items: items,
            value: _selectedCountry,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultMenuItem(Country country) {
    return Row(
      children: <Widget>[
        CurrencyPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Text("(${country.isoCode}) +${country.currencyCode}"),
      ],
    );
  }
}
