import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';
import 'package:gerenciamento_de_estoque/database/category.dart';
import 'package:gerenciamento_de_estoque/database/database.dart';

class WidgetCategoryForm extends StatefulWidget {
  const WidgetCategoryForm({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetProductFormState();
}

class _WidgetProductFormState extends State<WidgetCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;

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
                hint: "Coloque o nome da Categoria",
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nome da categoria é obrigatório";
                  }
                },
              ),
              createSaveCancelButton(context: context, function: (){
                if(_formKey.currentState!.validate()){
                  Database.categories.add(Category(name: name));
                  Navigator.pop(context);
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
