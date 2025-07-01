import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/services/product_service.dart';
import 'package:gerenciamento_de_estoque/core/services/category_service.dart';
import 'package:gerenciamento_de_estoque/core/services/stock_service.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product.dart';
import 'package:gerenciamento_de_estoque/domain/entities/category.dart';
import 'package:gerenciamento_de_estoque/domain/entities/supplier.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_text_form_field.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_save_cancel_buttons.dart';

class WidgetProductForm extends StatefulWidget {
  const WidgetProductForm({super.key});

  @override
  State<WidgetProductForm> createState() => _WidgetProductFormState();
}

class _WidgetProductFormState extends State<WidgetProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellPriceController = TextEditingController();
  
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  final StockService _stockService = StockService();
  
  Product? _product;
  bool _isLoading = false;
  bool _isEditing = false;
  
  List<Category> _categories = [];
  List<Supplier> _suppliers = [];
  Category? _selectedCategory;
  Supplier? _selectedSupplier;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Product) {
      _product = args;
      _isEditing = true;
      _populateForm();
    }
  }

  Future<void> _loadData() async {
    try {
      final categories = await _categoryService.getAllCategories();
      final suppliers = await _stockService.getAllSuppliers();
      
      setState(() {
        _categories = categories;
        _suppliers = suppliers;
      });
      
      if (_isEditing) {
        _populateForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _populateForm() {
    if (_product != null && _categories.isNotEmpty && _suppliers.isNotEmpty) {
      _nameController.text = _product!.name;
      _amountController.text = _product!.amount.toString();
      _purchasePriceController.text = _product!.purchasePrice.toString();
      _sellPriceController.text = _product!.sellPrice.toString();
      
      // Buscar categoria e fornecedor pelos IDs
      try {
        _selectedCategory = _categories.firstWhere(
          (cat) => cat.id == _product!.categoryId,
        );
      } catch (e) {
        _selectedCategory = null;
      }
      
      try {
        _selectedSupplier = _suppliers.firstWhere(
          (sup) => sup.id == _product!.supplierId,
        );
      } catch (e) {
        _selectedSupplier = null;
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    if (value.trim().length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantidade é obrigatória';
    }
    final amount = int.tryParse(value.trim());
    if (amount == null) {
      return 'Quantidade deve ser um número válido';
    }
    if (amount < 0) {
      return 'Quantidade não pode ser negativa';
    }
    return null;
  }

  String? _validatePurchasePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preço de compra é obrigatório';
    }
    final price = double.tryParse(value.trim());
    if (price == null) {
      return 'Preço deve ser um número válido';
    }
    if (price < 0) {
      return 'Preço não pode ser negativo';
    }
    return null;
  }

  String? _validateSellPrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preço de venda é obrigatório';
    }
    final price = double.tryParse(value.trim());
    if (price == null) {
      return 'Preço deve ser um número válido';
    }
    if (price < 0) {
      return 'Preço não pode ser negativo';
    }
    
    // Validação adicional: preço de venda não pode ser menor que preço de compra
    final purchasePrice = double.tryParse(_purchasePriceController.text.trim());
    if (purchasePrice != null && price < purchasePrice) {
      return 'Preço de venda não pode ser menor que o preço de compra';
    }
    
    return null;
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma categoria'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedSupplier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um fornecedor'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final product = Product(
        id: _product?.id,
        name: _nameController.text.trim(),
        amount: int.parse(_amountController.text.trim()),
        purchasePrice: double.parse(_purchasePriceController.text.trim()),
        sellPrice: double.parse(_sellPriceController.text.trim()),
        categoryId: _selectedCategory!.id!,
        supplierId: _selectedSupplier!.id!,
      );

      if (_isEditing && _product?.id != null) {
        await _productService.updateProduct(_product!.id!, product);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produto atualizado com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await _productService.addProduct(product);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produto criado com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar produto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _purchasePriceController.dispose();
    _sellPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Produto' : 'Novo Produto'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextFormField(
                      controller: _nameController,
                      label: 'Nome do Produto',
                      hint: 'Digite o nome do produto',
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _amountController,
                      label: 'Quantidade em Estoque',
                      hint: 'Digite a quantidade inicial',
                      validator: _validateAmount,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _purchasePriceController,
                      label: 'Preço de Compra',
                      hint: 'Digite o preço de compra',
                      validator: _validatePurchasePrice,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _sellPriceController,
                      label: 'Preço de Venda',
                      hint: 'Digite o preço de venda',
                      validator: _validateSellPrice,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Category>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Categoria',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text('${category.name} (${category.acronym})'),
                        );
                      }).toList(),
                      onChanged: (Category? value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione uma categoria';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Supplier>(
                      value: _selectedSupplier,
                      decoration: InputDecoration(
                        labelText: 'Fornecedor',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      items: _suppliers.map((supplier) {
                        return DropdownMenuItem<Supplier>(
                          value: supplier,
                          child: Text('${supplier.name} - ${supplier.enterprise}'),
                        );
                      }).toList(),
                      onChanged: (Supplier? value) {
                        setState(() {
                          _selectedSupplier = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione um fornecedor';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    CustomSaveCancelButtons(
                      context: context,
                      function: _saveProduct,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
