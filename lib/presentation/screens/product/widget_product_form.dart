import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/domain/entities/category.dart';
import 'package:gerenciamento_de_estoque/domain/entities/supplier.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_dropdown_form_menu.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_save_cancel_buttons.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_scaffold.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_text_form_field.dart';

class WidgetProductForm extends StatefulWidget {
  const WidgetProductForm({super.key});

  @override
  State<WidgetProductForm> createState() => _WidgetProductFormState();
}

class _WidgetProductFormState extends State<WidgetProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String productName;
  late Category category;
  late Supplier supplier;
  late double profitMargin;
  late double buyPrice;

  List<String> getCategories() {
    // This function would typically fetch categories from a database or API.
    // For this example, we will return a static list.
    return ["Electronics", "Clothing", "Groceries"];
  }

  List<String> getSuppliers() {
    // This function would typically fetch suppliers from a database or API.
    // For this example, we will return a static list.
    return ["Supplier A", "Supplier B", "Supplier C"];
  }

  @override
  Widget build(BuildContext context) {
    return CustomScafolld(
      title: "Cadastrar Produtos",
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              CustomTextFormField(
                label: "Nome",
                hint: "Coloque o nome do produto",
                onChanged: (value) {
                  setState(() {
                    productName = value;
                  });
                },
              ),
              CustomDropdownFormMenu(
                label: "Categoria",
                hint: "Selecione a categoria do produto",
                items: getCategories().map((categoryName) {
                  return DropdownMenuItem(
                    value: categoryName,
                    child: Text(categoryName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    category = value;
                  });
                },
              ),
              CustomDropdownFormMenu(
                label: "Fornecedor",
                hint: "Selecione o fornecedor do produto",
                items: getSuppliers().map((supplierName) {
                  return DropdownMenuItem(
                    value: supplierName,
                    child: Text(supplierName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    supplier = value;
                  });
                },
              ),
              CustomTextFormField(
                label: "Preço de compra",
                hint: "Coloque o preço de compra do produto",
                onChanged: (value) {
                  setState(() {
                    buyPrice = double.parse(value);
                  });
                },
              ),
              CustomTextFormField(
                label: "Margem de lucro (Sem '%')",
                hint: "Coloque a margem de lucro do produto",
                onChanged: (value) {
                  setState(() {
                    profitMargin = double.parse(value);
                  });
                },
              ),
              CustomSaveCancelButtons(
                context: context,
                function: () {
                  if (_formKey.currentState!.validate()) {
                    
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
