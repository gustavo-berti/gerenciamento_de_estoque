import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/routes/routes.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/category/widget_category_form.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/product/widget_product_form.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/supplier/widget_supplier_form.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/supplier/widget_supplier_list.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/category/widget_category_list.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/product/widget_product_list.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/login/widget_login.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/menu/widget_menu.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/stock/widget_stock.dart';

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
        Routes.home: (context) => WidgetStock(),
      },
    );
  }
}