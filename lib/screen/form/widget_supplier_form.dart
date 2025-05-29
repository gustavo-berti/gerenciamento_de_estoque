import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';
import 'package:gerenciamento_de_estoque/entity/database.dart';
import 'package:gerenciamento_de_estoque/entity/supplier.dart';
import 'package:gerenciamento_de_estoque/widgets/custom_save_cancel_buttons.dart';
import 'package:gerenciamento_de_estoque/widgets/custom_scaffold.dart';
import 'package:gerenciamento_de_estoque/widgets/custom_text_form_field.dart';

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
    return CustomScafolld(
      title: "Cadastrar Fornecedores",
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              CustomTextFormField(
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
              CustomTextFormField(
                label: "Telefone",
                hint: "Coloque o telefone do fornecedor",
                onChanged: (value) {
                  setState(() {
                    value != null ? phoneNumber = value : value = "";
                  });
                },
              ),
              CustomTextFormField(
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
              CustomTextFormField(
                label: "Email",
                hint: "Coloque o email do fornecedor",
                onChanged: (value) {
                  setState(() {
                    value != null ? name = value : value = "";
                  });
                },
              ),
              CustomTextFormField(
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
              CustomSaveCancelButtons(context: context, function: (){
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