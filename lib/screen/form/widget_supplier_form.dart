import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';
import 'package:gerenciamento_de_estoque/entity/database.dart';
import 'package:gerenciamento_de_estoque/entity/supplier.dart';

class WidgetSupplierForm extends StatefulWidget {
  const WidgetSupplierForm({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetSupplierForm();
}

class _WidgetSupplierForm extends State<WidgetSupplierForm>{
  final _formKey = GlobalKey<FormState>();
  late String name;
  String phoneNumber = "";
  late String enterprise;
  String email = "";
  late String address;

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
              createTextFormField(
                label: "Telefone",
                hint: "Coloque o telefone do fornecedor",
                onChanged: (value) {
                  setState(() {
                    value != null ? phoneNumber = value : value = "";
                  });
                },
              ),
              createTextFormField(
                label: "Empresa",
                hint: "Coloque o nome da empresa do fornecedor",
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nome da empresa é obrigatório";
                  }
                },
              ),
              createTextFormField(
                label: "Email",
                hint: "Coloque o email do fornecedor",
                onChanged: (value) {
                  setState(() {
                    value != null ? name = value : value = "";
                  });
                },
              ),
              createTextFormField(
                label: "Endereço",
                hint: "Coloque o CEP do fornecedor",
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
                  Database.suppliers.add(Supplier(name: name, address: address, email: email, enterprise: enterprise, phoneNumber: phoneNumber));
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