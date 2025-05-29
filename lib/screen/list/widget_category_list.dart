import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/routes.dart';
import 'package:gerenciamento_de_estoque/entity/database.dart';
import 'package:gerenciamento_de_estoque/widgets/custom_floating_button.dart';
import 'package:gerenciamento_de_estoque/widgets/custom_scaffold.dart';

class WidgetCategoryList extends StatelessWidget {
  const WidgetCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScafolld(
      title: "Categorias",
      body: Center(
        child: ListView.builder(
          itemCount:
              Database.categories.isEmpty ? 0 : Database.categories.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(Database.categories[index].name));
          },
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        onPressed: () => Navigator.pushNamed(context, Routes.categoryForm),
      ),
    );
  }
}
