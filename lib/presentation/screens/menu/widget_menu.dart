import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/routes/routes.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_elevated_button.dart';

class WidgetMenu extends StatelessWidget {
  const WidgetMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          text: "Estoque",
          function: () => Navigator.pushNamed(context, Routes.home),
        ),
        CustomElevatedButton(
          text: "Produtos",
          function: () => Navigator.pushNamed(context, Routes.productList),
        ),
        CustomElevatedButton(
          text: "Categorias",
          function: () => Navigator.pushNamed(context, Routes.categoryList),
        ),
        CustomElevatedButton(
          text: "Fornecedores",
          function: () => Navigator.pushNamed(context, Routes.supplierList),
        ),
        CustomElevatedButton(
          text: "Sair do sistema",
          function: () => Navigator.pushNamed(context, Routes.login),
        ),
      ],
    );
  }
}
