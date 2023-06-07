import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInput extends StatelessWidget {
  const PhoneInput({
    super.key,
    required this.phoneNumberController,
    required this.error,
  });

  final bool error;
  final TextEditingController phoneNumberController;
  static const String countryCode = '+380';

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: phoneNumberController,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(9),
      ],
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Номер телефону',
        prefixText: countryCode,
        errorText: error ? 'Невірний номер телефону' : null,
      ),
    );
  }
}
