import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_save_cancel_buttons.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_scaffold.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_text_form_field.dart';

class WidgetCategoryForm extends StatefulWidget {
  const WidgetCategoryForm({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetProductFormState();
}

class _WidgetProductFormState extends State<WidgetCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late String acronym;

  @override
  Widget build(BuildContext context) {
    return CustomScafolld(
      title: "Cadastrar Categoria",
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              CustomTextFormField(
                label: "Nome",
                hint: "Coloque o nome da Categoria",
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              CustomTextFormField(
                label: "Descrição",
                hint: "Coloque a descrição da Categoria",
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
              CustomTextFormField(
                label: "Sigla",
                hint: "Coloque a sigla da Categoria",
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              CustomSaveCancelButtons(context: context, function: (){
                if(_formKey.currentState!.validate()){

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
