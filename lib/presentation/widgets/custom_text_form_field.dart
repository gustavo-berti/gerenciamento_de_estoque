import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/utils/function.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscure;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool useDefaultValidator;

  const CustomTextFormField({
    Key? key,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.onChanged,
    this.validator,
    this.useDefaultValidator = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: TextFormField(
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
