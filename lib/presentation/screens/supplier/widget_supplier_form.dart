import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/domain/entities/address.dart';
import 'package:gerenciamento_de_estoque/domain/entities/city.dart';
import 'package:gerenciamento_de_estoque/domain/entities/country.dart';
import 'package:gerenciamento_de_estoque/domain/entities/state.dart'
    as customState;
import 'package:gerenciamento_de_estoque/domain/entities/database.dart';
import 'package:gerenciamento_de_estoque/domain/entities/supplier.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_save_cancel_buttons.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_scaffold.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_text_form_field.dart';

class WidgetSupplierForm extends StatefulWidget {
  const WidgetSupplierForm({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetSupplierForm();
}

class _WidgetSupplierForm extends State<WidgetSupplierForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  String phoneNumber = "";
  late String enterprise;
  String email = "";
  late Address address;
  late String street;
  late String number;
  late String addressLine2;
  late String city;
  late String state;
  late String acronym;
  late String country;

  @override
  Widget build(BuildContext context) {
    return CustomScafolld(
      title: "Cadastrar Fornecedores",
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
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
                ),
                CustomTextFormField(
                  label: "Telefone",
                  hint: "Coloque o telefone do fornecedor",
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                  },
                  useDefaultValidator: false,
                ),
                CustomTextFormField(
                  label: "Empresa",
                  hint: "Coloque o nome da empresa do fornecedor",
                  onChanged: (value) {
                    setState(() {
                      enterprise = value;
                    });
                  },
                ),
                CustomTextFormField(
                  label: "Email",
                  hint: "Coloque o email do fornecedor",
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  useDefaultValidator: false,
                ),
                CustomTextFormField(
                  label: "País",
                  hint: "Coloque o País do fornecedor",
                  onChanged: (value) {
                    setState(() {
                      country = value;
                    });
                  },
                ),
                CustomTextFormField(
                  label: "Estado",
                  hint: "Coloque o Estado do fornecedor",
                  onChanged: (value) {
                    setState(() {
                      state = value;
                    });
                  },
                ),
                CustomTextFormField(
                  label: "Sigla",
                  hint: "Coloque a sigla do estado",
                  onChanged: (value) {
                    setState(() {
                      country = value;
                    });
                  },
                ),
                CustomTextFormField(
                  label: "Cidade",
                  hint: "Coloque a Cidade do fornecedor",
                  onChanged: (value) {
                    setState(() {
                      city = value;
                    });
                  },
                ),
                CustomTextFormField(
                  label: "Rua",
                  hint: "Coloque a rua do fornecedor",
                  onChanged: (value) {
                    setState(() {
                      street = value;
                    });
                  },
                ),
                CustomTextFormField(
                  label: "Numero",
                  hint: "Coloque o numero do fornecedor",
                  onChanged: (value) {
                    setState(() {
                      number = value;
                    });
                  },
                ),
                CustomTextFormField(
                  label: "Complemento",
                  hint: "Coloque o complemento do fornecedor",
                  onChanged: (value) {
                    setState(() {
                      addressLine2 = value;
                    });
                  },
                ),
                CustomSaveCancelButtons(
                  context: context,
                  function: () {
                    if (_formKey.currentState!.validate()) {
                      Database.suppliers.add(
                        Supplier(
                          name: name,
                          address: Address(
                            addressLine2: addressLine2,
                            city: City(
                              name: city,
                              state: customState.State(
                                country: Country(country),
                                name: state,
                                acronym: acronym,
                              ),
                            ),
                            number: number,
                            street: street,
                          ),
                          email: email,
                          enterprise: enterprise,
                          phoneNumber: phoneNumber,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
