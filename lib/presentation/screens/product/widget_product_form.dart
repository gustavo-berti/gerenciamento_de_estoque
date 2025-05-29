import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/domain/entities/category.dart';
import 'package:gerenciamento_de_estoque/domain/entities/database.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product.dart';
import 'package:gerenciamento_de_estoque/domain/entities/supplier.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_dropdown_form_menu.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_save_cancel_buttons.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_scaffold.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_text_form_field.dart';

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
    return CustomScafolld(
      title: "Cadastrar Produtos",
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              CustomTextFormField(
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
                  return null;
                },
              ),
              CustomDropdownFormMenu(
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
                  return null;
                },
              ),
              CustomDropdownFormMenu(
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
                  return null;
                },
              ),
              CustomTextFormField(
                label: "Preço de compra",
                hint: "Coloque o preço de compra do produto",
                onChanged: (value) {
                  setState(() {
                    buyPrice = double.parse(value);
                  });
                },
                validator: (value) {
                  if (value == null || value == '') {
                    return "Preço de compra do produto é obrigatório";
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                label: "Margem de lucro (Sem '%')",
                hint: "Coloque a margem de lucro do produto",
                onChanged: (value) {
                  setState(() {
                    profitMargin = double.parse(value);
                  });
                },
                validator: (value) {
                  if (value == null || value == '') {
                    return "Margem de lucro é obrigatório";
                  }
                  return null;
                },
              ),
              CustomSaveCancelButtons(
                context: context,
                function: () {
                  if (_formKey.currentState!.validate()) {
                    Database.products.add(
                      Product(name: productName, category: category, supplier: supplier, amount: 0, buyPrice: buyPrice, sellPrice: (buyPrice * (1 + profitMargin / 100)),
                    ));
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
