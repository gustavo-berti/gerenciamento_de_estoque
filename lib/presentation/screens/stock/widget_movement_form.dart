import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/enums/movement_type.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product.dart';
import 'package:gerenciamento_de_estoque/core/services/stock_service.dart';
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
  final _stockService = StockService();
  final _amountController = TextEditingController();
  
  Product? _selectedProduct;
  MovementType? _selectedType;
  List<Product> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final products = await _stockService.getAllProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar produtos: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveMovement() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um produto'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione o tipo de movimentação'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = int.parse(_amountController.text.trim());
      
      final movement = await _stockService.addStockMovement(
        productId: _selectedProduct!.id!,
        amount: amount,
        type: _selectedType!,
      );

      if (movement != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movimentação registrada com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao registrar movimentação'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProducts,
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Movimentação'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomDropdownFormMenu(
                label: "Produto",
                hint: "Selecione o produto movimentado",
                items: _products.map((product) {
                  return DropdownMenuItem<Product>(
                    value: product,
                    child: Text('${product.name} (Estoque: ${product.amount})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProduct = value as Product?;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione um produto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                label: "Quantidade",
                hint: "Quantidade movimentada",
                controller: _amountController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a quantidade';
                  }
                  final amount = int.tryParse(value.trim());
                  if (amount == null || amount <= 0) {
                    return 'Quantidade deve ser um número positivo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomDropdownFormMenu(
                label: "Tipo",
                hint: "Tipo de movimentação",
                items: const [
                  DropdownMenuItem(
                    value: MovementType.entry,
                    child: Text("Entrada"),
                  ),
                  DropdownMenuItem(
                    value: MovementType.exit,
                    child: Text("Saída"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value as MovementType?;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione o tipo de movimentação';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              CustomElevatedButton(
                text: "Salvar",
                function: _saveMovement,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
