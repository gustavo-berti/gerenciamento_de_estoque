import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';
import 'package:gerenciamento_de_estoque/database/database.dart';
import 'package:gerenciamento_de_estoque/database/supplier.dart';

class WidgetSupplierForm extends StatefulWidget {
  const WidgetSupplierForm({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetSupplierForm();
}

class _WidgetSupplierForm extends State<WidgetSupplierForm>{
  final _formKey = GlobalKey<FormState>();
  late String name;

  @override
  Widget build(BuildContext context) {
    return createScaffold(
      title: "Cadastrar Fornecedores",
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              createTextFormField(
                label: "Nome",
                hint: "Coloque o nome do fornecedor",
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
                  Database.suppliers.add(Supplier(name: name));
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