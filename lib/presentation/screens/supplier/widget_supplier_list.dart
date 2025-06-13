import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/routes/routes.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_floating_button.dart';

class WidgetSupplierList extends StatelessWidget {
  const WidgetSupplierList({super.key});

  List<String> getSuppliers() {
    // This function would typically fetch suppliers from a database or API.
    // For this example, we will return a static list.
    return ["Supplier A", "Supplier B", "Supplier C"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: getSuppliers().length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(getSuppliers()[index]));
          },
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        onPressed: () => Navigator.pushNamed(context, Routes.supplierForm),
      ),
    );
  }
}