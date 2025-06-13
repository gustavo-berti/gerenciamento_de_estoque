import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/routes/routes.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_floating_button.dart';

class WidgetProductList extends StatelessWidget {
  const WidgetProductList({super.key});
  static List<DropdownMenuItem> items = [
    DropdownMenuItem(value: null, child: Text("Selecione um produto")),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(items[index].value?.toString() ?? "Produto ${index + 1}"));
          },
        ),
      ),
      floatingActionButton: CustomFloatingButton(onPressed: (){
        Navigator.pushNamed(context, Routes.productForm);
      }, ),
    );
  }
}