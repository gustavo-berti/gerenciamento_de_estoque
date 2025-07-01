import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/routes/routes.dart';
import 'package:gerenciamento_de_estoque/domain/entities/supplier.dart';
import 'package:gerenciamento_de_estoque/domain/entities/user.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/category/widget_category_form.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/home.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/product/widget_product_form.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/supplier/widget_supplier_form.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/supplier/widget_supplier_list.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/category/widget_category_list.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/product/widget_product_list.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/user/widget_user_form.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/user/widget_user_list.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/widget_login.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/stock/widget_stock.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de Estoque',
      theme: ThemeData(primarySwatch: Colors.cyan),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => WidgetLogin(),
        Routes.productForm: (context) => WidgetProductForm(),
        Routes.productList: (context) => WidgetProductList(),
        Routes.categoryForm: (context) => WidgetCategoryForm(),
        Routes.categoryList: (context) => WidgetCategoryList(),
        Routes.supplierForm: (context) {
          final supplier = ModalRoute.of(context)?.settings.arguments as Supplier?;
          return WidgetSupplierForm(supplier: supplier);
        },
        Routes.supplierList: (context) => WidgetSupplierList(),
        Routes.userForm: (context) {
          final user = ModalRoute.of(context)?.settings.arguments as User?;
          return WidgetUserForm(user: user);
        },
        Routes.userList: (context) => WidgetUserList(),
        Routes.stock: (context) => WidgetStock(),
        Routes.home: (context) => Home(),
      },
    );
  }
}