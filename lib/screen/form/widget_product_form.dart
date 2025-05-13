import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';
import 'package:gerenciamento_de_estoque/entity/category.dart';
import 'package:gerenciamento_de_estoque/entity/database.dart';
import 'package:gerenciamento_de_estoque/entity/product.dart';
import 'package:gerenciamento_de_estoque/entity/supplier.dart';

class WidgetProductForm extends StatefulWidget {
  const WidgetProductForm({super.key});

  @override
  State<WidgetProductForm> createState() => _WidgetProductFormState();
}

class _WidgetProductFormState extends State<WidgetProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String productName;
  late Category category;
  late Supplier supplier;
  late double profitMargin;
  late double buyPrice;

  @override
  Widget build(BuildContext context) {
    return createScaffold(
      title: "Cadastrar Produtos",
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              createTextFormField(
                label: "Nome",
                hint: "Coloque o nome do produto",
                onChanged: (value) {
                  setState(() {
                    productName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value == '') {
                    return "Nome do produto é obrigatório";
                  }
                },
              ),
              createDropdownFormField(
                label: "Categoria",
                hint: "Selecione a categoria do produto",
                items:
                    Database.categories.isEmpty
                        ? []
                        : Database.categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                onChanged: (value) {
                  setState(() {
                    category = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Categoria é obrigatório";
                  }
                },
              ),
              createDropdownFormField(
                label: "Fornecedor",
                hint: "Selecione o fornecedor do produto",
                items:
                    Database.suppliers.isEmpty
                        ? []
                        : Database.suppliers.map((supplier) {
                          return DropdownMenuItem(
                            value: supplier,
                            child: Text(supplier.name),
                          );
                        }).toList(),
                onChanged: (value) {
                  setState(() {
                    supplier = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Forncedor é obrigatório";
                  }
                },
              ),
              createTextFormField(
                label: "Preço de compra",
                hint: "Coloque o preço de compra do produto",
                onChanged: (value) {
                  setState(() {
                    buyPrice = value;
                  });
                },
                validator: (value) {
                  if (value == null || value == '') {
                    return "Preço de compra do produto é obrigatório";
                  }
                },
              ),
              createTextFormField(
                label: "Margem de lucro",
                hint: "Coloque a margem de lucro do produto",
                onChanged: (value) {
                  setState(() {
                    profitMargin = value;
                  });
                },
                validator: (value) {
                  if (value == null || value == '') {
                    return "Margem de lucro é obrigatório";
                  }
                },
              ),
              createSaveCancelButton(
                context: context,
                function: () {
                  if (_formKey.currentState!.validate()) {
                    Database.products.add(
                      Product(name: productName, category: category, supplier: supplier, amount: 0, buyPrice: buyPrice, sellPrice: (buyPrice*profitMargin)),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
