import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? function;
  final WidgetStateProperty<OutlinedBorder>? shape;
  final WidgetStateProperty<Size> size;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.function,
    this.shape,
    this.size = const WidgetStatePropertyAll<Size>(Size.fromWidth(200)),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          const Color.fromRGBO(187, 222, 251, 1),
        ),
        fixedSize: size,
        shape: shape,
      ),
      child: Text(text, style: const TextStyle(color: Colors.black, fontSize: 17)),
    );
  }
}
