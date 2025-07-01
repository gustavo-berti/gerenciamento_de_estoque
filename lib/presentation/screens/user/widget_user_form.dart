import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/services/user_service.dart';
import 'package:gerenciamento_de_estoque/domain/entities/user.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_save_cancel_buttons.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_scaffold.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_text_form_field.dart';

class WidgetUserForm extends StatefulWidget {
  final User? user; // Para edição

  const WidgetUserForm({super.key, this.user});

  @override
  State<StatefulWidget> createState() => _WidgetUserFormState();
}

class _WidgetUserFormState extends State<WidgetUserForm> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  
  // Controllers para os campos
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _isLoading = false;
  bool _isEditing = false;
  String _selectedRole = 'user';
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.user != null;
    
    // Inicializar controllers
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    // Se estiver editando, preencher os campos
    if (_isEditing) {
      _fillFormForEditing();
    }
  }

  void _fillFormForEditing() {
    final user = widget.user!;
    _nameController.text = user.name;
    _emailController.text = user.email;
    _selectedRole = user.role;
    // Não preencher senha por segurança
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isEditing) {
        // Atualizar usuário existente
        final success = await _userService.updateUser(
          userId: widget.user!.id!,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          role: _selectedRole,
        );

        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Usuário "${_nameController.text}" atualizado com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erro ao atualizar usuário. Verifique se o email já existe.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        // Criar novo usuário
        final user = await _userService.addUser(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          role: _selectedRole,
        );

        if (user != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Usuário "${user.name}" criado com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erro ao criar usuário. Verifique se o email já existe.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScafolld(
      title: _isEditing ? "Editar Usuário" : "Novo Usuário",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Nome
                      CustomTextFormField(
                        controller: _nameController,
                        label: "Nome Completo",
                        hint: "Digite o nome completo",
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nome é obrigatório';
                          }
                          if (value.trim().length < 2) {
                            return 'Nome deve ter pelo menos 2 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email
                      CustomTextFormField(
                        controller: _emailController,
                        label: "Email",
                        hint: "Digite o email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email é obrigatório';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Role (Função)
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: "Função",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'user', child: Text('Usuário')),
                          DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedRole = value;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecione uma função';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Senha (apenas para novo usuário ou alteração)
                      if (!_isEditing) ...[
                        CustomTextFormField(
                          controller: _passwordController,
                          label: "Senha",
                          hint: "Digite a senha",
                          obscure: !_showPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Senha é obrigatória';
                            }
                            if (value.length < 6) {
                              return 'Senha deve ter pelo menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        
                        // Botão para mostrar/ocultar senha
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                            label: Text(_showPassword ? 'Ocultar senha' : 'Mostrar senha'),
                          ),
                        ),
                        const SizedBox(height: 8),

                        CustomTextFormField(
                          controller: _confirmPasswordController,
                          label: "Confirmar Senha",
                          hint: "Digite a senha novamente",
                          obscure: !_showPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirmação de senha é obrigatória';
                            }
                            if (value != _passwordController.text) {
                              return 'Senhas não coincidem';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      if (_isEditing) ...[
                        Card(
                          color: Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Icon(Icons.info, color: Colors.blue),
                                const SizedBox(height: 8),
                                const Text(
                                  'Para alterar a senha, use a opção "Alterar Senha" no menu do usuário.',
                                  style: TextStyle(color: Colors.blue),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ),

              // Botões
              CustomSaveCancelButtons(
                context: context,
                function: _saveUser,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
