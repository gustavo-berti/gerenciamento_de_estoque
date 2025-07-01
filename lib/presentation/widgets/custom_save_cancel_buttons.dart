import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_elevated_button.dart';

class CustomSaveCancelButtons extends StatelessWidget {
  final VoidCallback function;
  final BuildContext context;
  final bool isLoading;

  const CustomSaveCancelButtons({
    super.key,
    required this.context, 
    required this.function,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomElevatedButton(
          text: isLoading ? "Salvando..." : "Salvar",
          function: isLoading ? null : function,
          size: const WidgetStatePropertyAll<Size>(Size.fromWidth(110)),
        ),
        const Padding(padding: EdgeInsets.all(2)),
        CustomElevatedButton(
          text: "Cancelar",
          function: isLoading ? null : () {
            Navigator.pop(context);
          },
          size: const WidgetStatePropertyAll<Size>(Size.fromWidth(130)),
        ),
      ],
    );
  }
}