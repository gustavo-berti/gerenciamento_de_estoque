import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/widgets/custom_elevated_button.dart';

class CustomSaveCancelButtons extends StatelessWidget {
  final VoidCallback function;
  final BuildContext context;

  CustomSaveCancelButtons({required this.context, required this.function});

  @override
  Widget build(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomElevatedButton(
        text: "Salvar",
        function: function,
        size: WidgetStatePropertyAll<Size>(Size.fromWidth(100)),
      ),
      Padding(padding: EdgeInsets.all(2)),
      CustomElevatedButton(
        text: "Cancelar",
        function: () {
          Navigator.pop(context);
        },
        size: WidgetStatePropertyAll<Size>(Size.fromWidth(110)),
      ),
    ],
  );
}
}