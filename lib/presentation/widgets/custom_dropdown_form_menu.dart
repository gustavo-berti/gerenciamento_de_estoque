import 'package:flutter/material.dart';

class CustomDropdownFormMenu extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final String label;
  final String hint;
  final ValueChanged<dynamic>? onChanged;
  final FormFieldValidator? validator;

  CustomDropdownFormMenu({
    required this.label,
    required this.hint,
    required this.items,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: DropdownButtonFormField(
        items: items,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          labelText: label,
          hintText: hint,
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
