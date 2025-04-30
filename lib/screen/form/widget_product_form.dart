import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';
import 'package:gerenciamento_de_estoque/database/database.dart';

class WidgetProductForm extends StatefulWidget {
  const WidgetProductForm({super.key});

  @override
  State<WidgetProductForm> createState() => _WidgetProductFormState();
}

class _WidgetProductFormState extends State<WidgetProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String productName;

  @override
  Widget build(BuildContext context) {
    return createScaffold(
      body: Form(
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
                items: Database.categories.isEmpty ? [] : Database.categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
