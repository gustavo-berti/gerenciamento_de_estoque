import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/routes/routes.dart';
import 'package:gerenciamento_de_estoque/domain/entities/database.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_floating_button.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_scaffold.dart';

class WidgetProductList extends StatelessWidget {
  const WidgetProductList({super.key});
  
  @override
  Widget build(BuildContext context) {
    return CustomScafolld(
      title: "Produtos",
      body: Center(
        child: ListView.builder(
          itemCount: Database.products.isEmpty ? 0 : Database.products.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(Database.products[index].name));
          },
        ),
      ),
      floatingActionButton: CustomFloatingButton(onPressed: (){
        Navigator.pushNamed(context, Routes.productForm);
      }, ),
    );
  }
}