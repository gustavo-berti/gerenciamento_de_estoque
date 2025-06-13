import 'package:flutter/material.dart';

class CustomScafolld extends StatelessWidget{
  final Widget body;
  final String title;
  final Widget? floatingActionButton;
  final bool hasDrawer;
  final PreferredSizeWidget? bottom;

  CustomScafolld({
    required this.body,
    this.title = "Gerenciamento de Estoque",
    this.floatingActionButton,
    this.hasDrawer = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromRGBO(187, 222, 251, 1),
        centerTitle: true,
        bottom: bottom,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
