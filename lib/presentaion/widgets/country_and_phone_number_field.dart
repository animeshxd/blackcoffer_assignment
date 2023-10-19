import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'country_search_delegate.dart';

final _countries = Map.fromEntries(countries.map((e) => MapEntry(e.code, e)));

class CountryAndPhoneNumberField extends StatefulWidget {
  const CountryAndPhoneNumberField({
    super.key,
    required this.onValidated,
    this.onChanged,
    this.country = 'IN',
    this.errorText,
  });
  final void Function(PhoneNumber value) onValidated;
  final void Function(PhoneNumber value)? onChanged;
  final String? errorText;

  final String country;
  @override
  State<CountryAndPhoneNumberField> createState() =>
      CountryAndPhoneNumberFieldState();
}

class CountryAndPhoneNumberFieldState
    extends State<CountryAndPhoneNumberField> {
  final _numberController = TextEditingController();

  late var _selectedCountry = _countries[widget.country]!;
  late String? _errorText = widget.errorText;
  @override
  void dispose() {
    super.dispose();
    _numberController.dispose();
  }

  late bool isError = widget.errorText != null;
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;
    final textInputStyle = textStyle?.copyWith(fontWeight: FontWeight.w400);
    debugPrint(textInputStyle?.fontSize.toString());
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                InkWell(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_selectedCountry.flag),
                      Text(' +', style: textInputStyle),
                      Text(
                        _selectedCountry.fullCountryCode,
                        style: textInputStyle,
                      ),
                      const Icon(Icons.keyboard_arrow_down, size: 15)
                    ],
                  ),
                  onTap: () async {
                    final country = await showSearch<Country>(
                      context: context,
                      delegate: CountrySearchDelegate(),
                    );
                    setState(() {
                      _selectedCountry = country ?? _selectedCountry;
                    });
                  },
                ),
                Expanded(flex: 0, child: Text('  ', style: textInputStyle)),
                Expanded(
                  flex: 7,
                  child: TextField(
                    controller: _numberController,
                    decoration: InputDecoration(
                      hintText: ' Enter Phone Number',
                      hintStyle: textInputStyle,
                      border: InputBorder.none,
                      counterText: '',
                      isCollapsed: true,
                    ),
                    cursorColor: widget.errorText == null ? null : Colors.red,
                    maxLength: _selectedCountry.maxLength,
                    style: textInputStyle,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      var phoneNumber = PhoneNumber(
                        countryCode: _selectedCountry.fullCountryCode,
                        number: value,
                      );
                      setState(() {
                        isError = false;
                        _errorText = null;
                      });
                      widget.onChanged?.call(phoneNumber);

                      if (value.length > _selectedCountry.maxLength ||
                          value.length < _selectedCountry.minLength) {
                        setState(() {
                          isError = true;
                          _errorText = 'Invalid phone number';
                        });
                      } else {
                        widget.onValidated(phoneNumber);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          if (isError)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class PhoneNumber {
  final String countryCode;
  final String number;

  PhoneNumber({required this.countryCode, required this.number});

  String get completeNumber => "+$countryCode$number";
}
