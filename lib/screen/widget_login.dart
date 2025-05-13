import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/routes.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';

class WidgetLogin extends StatelessWidget {
  const WidgetLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return createScaffold(
      body: Form(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              createTextFormField(label: "Login", hint: "Coloque seu login"),
              createTextFormField(label: "Senha", hint: "Coloque sua senha", obscure: true),
              createElevatedButton(
                text: "Entrar",
                function: () {
                  Navigator.pushNamed(context, Routes.menu);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
