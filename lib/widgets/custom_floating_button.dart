import 'package:flutter/material.dart';

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  CustomFloatingButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color.fromRGBO(187, 222, 251, 1),
      foregroundColor: Colors.black,
      shape: CircleBorder(),
      child: Icon(Icons.add),
    );
  }
}