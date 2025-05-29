import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/enums/movement_type.dart';
import 'package:gerenciamento_de_estoque/domain/entities/database.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product.dart';
import 'package:gerenciamento_de_estoque/domain/entities/stockMovement.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_dropdown_form_menu.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_elevated_button.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_text_form_field.dart';

class WidgetMovementForm extends StatefulWidget {
  const WidgetMovementForm({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetMovementForm();
}

class _WidgetMovementForm extends State<WidgetMovementForm> {
  final _formKey = GlobalKey<FormState>();
  late Product product;
  late int amount;
  late MovementType type;

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
                return null;
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
                return null;
              },
            ),
            CustomDropdownFormMenu(
              label: "Tipo",
              hint: "Tipo de movimentação",
              items: [
                DropdownMenuItem(value: MovementType.entry, child: Text("Entrada")),
                DropdownMenuItem(value: MovementType.exit, child: Text("Saida")),
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
                return null;
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
