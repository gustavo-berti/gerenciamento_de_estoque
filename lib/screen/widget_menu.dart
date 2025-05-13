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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: GridView.count(
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                shrinkWrap: true,
                children: [
                  createMenuButton(
                    text: "Produtos",
                    function:
                        () => Navigator.pushNamed(context, Routes.productList),
                  ),
                  createMenuButton(
                    text: "Categorias",
                    function:
                        () => Navigator.pushNamed(context, Routes.categoryList),
                  ),
                  createMenuButton(
                    text: "Fornecedores",
                    function:
                        () => Navigator.pushNamed(context, Routes.supplierList),
                  ),
                  createMenuButton(
                    text: "Estoque",
                    function: () => Navigator.pushNamed(context, Routes.stock),
                  ),
                ],
              ),
            ),
            createMenuButton(
              text: "Sair do sistema",
              function: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
