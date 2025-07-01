import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/services/category_service.dart';
import 'package:gerenciamento_de_estoque/domain/entities/category.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_text_form_field.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_save_cancel_buttons.dart';

class WidgetCategoryForm extends StatefulWidget {
  const WidgetCategoryForm({super.key});

  @override
  State<WidgetCategoryForm> createState() => _WidgetCategoryFormState();
}

class _WidgetCategoryFormState extends State<WidgetCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _acronymController = TextEditingController();
  
  final CategoryService _categoryService = CategoryService();
  
  Category? _category;
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Category) {
      _category = args;
      _isEditing = true;
      _populateForm();
    }
  }

  void _populateForm() {
    if (_category != null) {
      _nameController.text = _category!.name;
      _descriptionController.text = _category!.description;
      _acronymController.text = _category!.acronym;
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

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Descrição é obrigatória';
    }
    if (value.trim().length < 5) {
      return 'Descrição deve ter pelo menos 5 caracteres';
    }
    return null;
  }

  String? _validateAcronym(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Sigla é obrigatória';
    }
    if (value.trim().length < 2 || value.trim().length > 5) {
      return 'Sigla deve ter entre 2 e 5 caracteres';
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value.trim())) {
      return 'Sigla deve conter apenas letras';
    }
    return null;
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final category = Category(
        id: _category?.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        acronym: _acronymController.text.trim().toUpperCase(),
      );

      if (_isEditing && _category?.id != null) {
        await _categoryService.updateCategory(_category!.id!, category);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Categoria atualizada com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await _categoryService.addCategory(category);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Categoria criada com sucesso'),
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
            content: Text('Erro ao salvar categoria: $e'),
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
    _descriptionController.dispose();
    _acronymController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Categoria' : 'Nova Categoria'),
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
                      label: 'Nome',
                      hint: 'Digite o nome da categoria',
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _descriptionController,
                      label: 'Descrição',
                      hint: 'Digite a descrição da categoria',
                      validator: _validateDescription,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _acronymController,
                      label: 'Sigla',
                      hint: 'Digite a sigla da categoria (2-5 letras)',
                      validator: _validateAcronym,
                      onChanged: (value) {
                        // Converter para maiúsculo automaticamente
                        final newValue = value.toUpperCase();
                        if (value != newValue) {
                          _acronymController.value = _acronymController.value.copyWith(
                            text: newValue,
                            selection: TextSelection.collapsed(offset: newValue.length),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    CustomSaveCancelButtons(
                      context: context,
                      function: _saveCategory,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
