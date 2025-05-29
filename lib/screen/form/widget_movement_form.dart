import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';
import 'package:gerenciamento_de_estoque/config/enum.dart';
import 'package:gerenciamento_de_estoque/entity/database.dart';
import 'package:gerenciamento_de_estoque/entity/product.dart';
import 'package:gerenciamento_de_estoque/entity/stockMovement.dart';
import 'package:gerenciamento_de_estoque/widgets/custom_dropdown_form_menu.dart';
import 'package:gerenciamento_de_estoque/widgets/custom_elevated_button.dart';
import 'package:gerenciamento_de_estoque/widgets/custom_text_form_field.dart';

class WidgetMovementForm extends StatefulWidget {
  const WidgetMovementForm({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetMovementForm();
}

class _WidgetMovementForm extends State<WidgetMovementForm> {
  final _formKey = GlobalKey<FormState>();
  late Product product;
  late int amount;
  late MovimentType type;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: [
            CustomDropdownFormMenu(
              label: "Produto",
              hint: "Selecione o produto movimentado",
              items:
                  Database.stock.products.isEmpty
                      ? []
                      : Database.stock.products.map((prod) {
                        return DropdownMenuItem(
                          value: prod,
                          child: Text(prod.name),
                        );
                      }).toList(),
              onChanged: (value) {
                setState(() {
                  product = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Produto é obrigatório";
                }
              },
            ),
            CustomTextFormField(
              label: "Quantidade",
              hint: "Quantidade movimentada",
              onChanged: (value) {
                setState(() {
                  amount = int.parse(value);
                });
              },
              validator: (value) {
                if (value == null || value == "") {
                  return "Quantidade é obrigatória";
                }
              },
            ),
            CustomDropdownFormMenu(
              label: "Tipo",
              hint: "Tipo de movimentação",
              items: [
                DropdownMenuItem(value: MovimentType.entry, child: Text("Entrada")),
                DropdownMenuItem(value: MovimentType.exit, child: Text("Saida")),
              ],
              onChanged: (value) {
                setState(() {
                  type = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Tipo é obrigatório";
                }
              },
            ),
            CustomElevatedButton(
              text: "Salvar",
              function: () {
                if (_formKey.currentState!.validate()) {
                  Database.stock.updateStock(
                    StockMovement(
                      product: product,
                      amount: amount,
                      date: DateTime.now(),
                      type: type,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
