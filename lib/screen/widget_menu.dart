import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';
import 'package:gerenciamento_de_estoque/config/routes.dart';

class WidgetMenu extends StatelessWidget {
  const WidgetMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return createScaffold(
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(5)),
            newButton(text: "Produtos", function: () => Navigator.pushNamed(context, Routes.productList),),
            newButton(text: "Categorias", function: () => Navigator.pushNamed(context, Routes.categoryList),),
            newButton(text: "Fornecedores", function: () => Navigator.pushNamed(context, Routes.supplierList),),
            newButton(text: "Estoque", function: () => Navigator.pushNamed(context, Routes.stock),),
            newButton(text: "Sair do sistema", function: () => Navigator.pop(context),),
          ],
        ),
      ),
    );
  }
}
