import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/menu/widget_menu.dart';

class CustomScafolld extends StatelessWidget{
  final Widget body;
  final String title;
  final Widget? floatingActionButton;
  final bool hasDrawer;

  CustomScafolld({
    required this.body,
    this.title = "Gerenciamento de Estoque",
    this.floatingActionButton,
    this.hasDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: hasDrawer ? Drawer(
        
        width: MediaQuery.of(context).size.width*0.5,
        child: WidgetMenu()) : null,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromRGBO(187, 222, 251, 1),
        centerTitle: true,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
