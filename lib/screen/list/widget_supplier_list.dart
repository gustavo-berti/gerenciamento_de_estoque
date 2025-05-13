import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';
import 'package:gerenciamento_de_estoque/config/routes.dart';
import 'package:gerenciamento_de_estoque/entity/database.dart';

class WidgetSupplierList extends StatelessWidget {
  const WidgetSupplierList({super.key});

  @override
  Widget build(BuildContext context) {
    return createScaffold(
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
      floatingActionButton: createFloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Routes.supplierForm),
      ),
    );
  }
}