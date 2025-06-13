import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/category/widget_category_list.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/product/widget_product_list.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/stock/widget_stock.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/supplier/widget_supplier_list.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_scaffold.dart';

class Home extends StatelessWidget {
  final tabs = ["Estoque", "Produtos", "Fornecedores", "Categorias", "Usuario"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: CustomScafolld(
        bottom: TabBar(
          isScrollable: true,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
        ),
        body: const TabBarView(children: [
          WidgetStock(),
          WidgetProductList(),
          WidgetCategoryList(),
          WidgetSupplierList(),
          WidgetSupplierList(),
        ]),
      ),
    );
  }
}
