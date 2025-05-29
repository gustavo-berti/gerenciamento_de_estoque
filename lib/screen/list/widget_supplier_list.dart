import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';
import 'package:gerenciamento_de_estoque/config/routes.dart';
import 'package:gerenciamento_de_estoque/entity/database.dart';
import 'package:gerenciamento_de_estoque/widgets/custom_floating_button.dart';
import 'package:gerenciamento_de_estoque/widgets/custom_scaffold.dart';

class WidgetSupplierList extends StatelessWidget {
  const WidgetSupplierList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScafolld(
      title: "Fornecedores",
      body: Center(
        child: ListView.builder(
          itemCount:
              Database.suppliers.isEmpty ? 0 : Database.suppliers.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(Database.suppliers[index].name));
          },
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        onPressed: () => Navigator.pushNamed(context, Routes.supplierForm),
      ),
    );
  }
}