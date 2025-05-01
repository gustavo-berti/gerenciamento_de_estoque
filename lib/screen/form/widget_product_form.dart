import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';
import 'package:gerenciamento_de_estoque/database/category.dart';
import 'package:gerenciamento_de_estoque/database/database.dart';
import 'package:gerenciamento_de_estoque/database/product.dart';

class WidgetProductForm extends StatefulWidget {
  const WidgetProductForm({super.key});

  @override
  State<WidgetProductForm> createState() => _WidgetProductFormState();
}

class _WidgetProductFormState extends State<WidgetProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String productName;
  late Category category;

  @override
  Widget build(BuildContext context) {
    return createScaffold(
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
              createSaveCancelButton(
                context: context,
                function: () {
                  if (_formKey.currentState!.validate()) {
                    Database.products.add(
                      Product(name: productName, category: category),
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
