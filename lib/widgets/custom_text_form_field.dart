import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscure;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator? validator;

  CustomTextFormField({
    required this.label,
    required this.hint,
    this.obscure = false,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          labelText: label,
          hintText: hint,
        ),
        obscureText: obscure,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
