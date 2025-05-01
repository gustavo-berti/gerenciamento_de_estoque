import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/routes.dart';
import 'package:gerenciamento_de_estoque/screen/form/widget_category_form.dart';
import 'package:gerenciamento_de_estoque/screen/form/widget_product_form.dart';
import 'package:gerenciamento_de_estoque/screen/form/widget_supplier_form.dart';
import 'package:gerenciamento_de_estoque/screen/list/widget_supplier_list.dart';
import 'package:gerenciamento_de_estoque/screen/list/widget_category_list.dart';
import 'package:gerenciamento_de_estoque/screen/list/widget_product_list.dart';
import 'package:gerenciamento_de_estoque/screen/widget_login.dart';
import 'package:gerenciamento_de_estoque/screen/widget_menu.dart';
import 'package:gerenciamento_de_estoque/screen/widget_stock_entry.dart';
import 'package:gerenciamento_de_estoque/screen/widget_stock_out.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de Estoque',
      theme: ThemeData(primarySwatch: Colors.cyan),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        Routes.login: (context) => WidgetLogin(),
        Routes.menu: (context) => WidgetMenu(),
        Routes.productForm: (context) => WidgetProductForm(),
        Routes.productList: (context) => WidgetProductList(),
        Routes.categoryForm: (context) => WidgetCategoryForm(),
        Routes.categoryList: (context) => WidgetCategoryList(),
        Routes.supplierForm: (context) => WidgetSupplierForm(),
        Routes.supplierList: (context) => WidgetSupplierList(),
        Routes.stockEntry: (context) => WidgetStockEntry(),
        Routes.stockOut: (context) => WidgetStockOut(),
      },
    );
  }
}