import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';
import 'package:gerenciamento_de_estoque/config/routes.dart';
import 'package:gerenciamento_de_estoque/database/database.dart';

class WidgetProductList extends StatelessWidget {
  const WidgetProductList({super.key});


  
  @override
  Widget build(BuildContext context) {
    return createScaffold(
      body: Center(
        child: ListView.builder(
          itemCount: Database.products.isEmpty ? 0 : Database.products.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(Database.products[index].name));
          },
        ),
      ),
      floatingActionButton: createFloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, Routes.productForm);
      }, ),
    );
  }
}