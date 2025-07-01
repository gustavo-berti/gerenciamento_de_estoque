import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/utils/function.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscure;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool useDefaultValidator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;

  const CustomTextFormField({
    Key? key,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.onChanged,
    this.validator,
    this.useDefaultValidator = true,
    this.controller,
    this.keyboardType,
    this.textCapitalization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          labelText: label,
          hintText: hint,
        ),
        obscureText: obscure,
        onChanged: onChanged,
        validator: combinedValidator(
          useDefaultValidator: useDefaultValidator,
          customValidator: validator,
        ),
      ),
    );
  }
}
