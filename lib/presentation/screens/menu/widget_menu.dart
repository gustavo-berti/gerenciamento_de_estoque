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
        SizedBox(height: 10,),
        CustomElevatedButton(
          text: "Produtos",
          function: () => Navigator.pushNamed(context, Routes.productList),
        ),
        SizedBox(height: 10,),
        CustomElevatedButton(
          text: "Categorias",
          function: () => Navigator.pushNamed(context, Routes.categoryList),
        ),
        SizedBox(height: 10,),
        CustomElevatedButton(
          text: "Fornecedores",
          function: () => Navigator.pushNamed(context, Routes.supplierList),
        ),
        SizedBox(height: 10,),
        CustomElevatedButton(
          text: "Sair do sistema",
          function: () => Navigator.pushNamed(context, Routes.login),
        ),
      ],
    );
  }
}
