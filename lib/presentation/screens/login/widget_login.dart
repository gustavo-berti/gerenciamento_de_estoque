import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/routes/routes.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_elevated_button.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_scaffold.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_text_form_field.dart';

class WidgetLogin extends StatelessWidget {
  const WidgetLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScafolld(
      body: Form(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFormField(label: "Login", hint: "Coloque seu login"),
              CustomTextFormField(label: "Senha", hint: "Coloque sua senha", obscure: true),
              CustomElevatedButton(
                text: "Entrar",
                function: () {
                  Navigator.pushNamed(context, Routes.home);
                },
              ),
            ],
          ),
        ),
      ),
      hasDrawer: false,
    );
  }
}
