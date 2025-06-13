import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/routes/routes.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_floating_button.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_scaffold.dart';

class WidgetCategoryList extends StatelessWidget {
  const WidgetCategoryList({super.key});

  List<String> getCategories() {
    // This function would typically fetch categories from a database or API.
    // For this example, we will return a static list.
    return ["Electronics", "Clothing", "Groceries"];
  }

  @override
  Widget build(BuildContext context) {
    return CustomScafolld(
      title: "Categorias",
      body: Center(
        child: ListView.builder(
          itemCount: getCategories().length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(getCategories()[index]));
          },
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        onPressed: () => Navigator.pushNamed(context, Routes.categoryForm),
      ),
    );
  }
}
