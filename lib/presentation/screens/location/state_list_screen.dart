import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/services/state_service.dart';
import 'package:gerenciamento_de_estoque/core/services/country_service.dart';
import 'package:gerenciamento_de_estoque/domain/entities/state.dart' as EntityState;
import 'package:gerenciamento_de_estoque/domain/entities/country.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_floating_button.dart';

class StateListScreen extends StatefulWidget {
  const StateListScreen({super.key});

  @override
  State<StateListScreen> createState() => _StateListScreenState();
}

class _StateListScreenState extends State<StateListScreen> {
  final StateService _stateService = StateService();
  final CountryService _countryService = CountryService();
  List<EntityState.State> _states = [];
  List<Country> _countries = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final [states, countries] = await Future.wait([
        _stateService.getAllStates(),
        _countryService.getAllCountries(),
      ]);
      
      setState(() {
        _states = states as List<EntityState.State>;
        _countries = countries as List<Country>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar dados: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteState(EntityState.State state, int index) async {
    final canDelete = await _stateService.canDeleteState(state.id!);
    if (!canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não é possível excluir este estado pois possui cidades cadastradas'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja excluir o estado "${state.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final success = await _stateService.deleteState(state.id!);
        if (success) {
          setState(() {
            _states.removeAt(index);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Estado "${state.name}" excluído com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao excluir estado'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir estado: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addOrEditState([EntityState.State? state]) {
    showDialog(
      context: context,
      builder: (context) => StateFormDialog(
        state: state,
        countries: _countries,
        onSaved: _loadData,
      ),
    );
  }

  String _getCountryName(int countryId) {
    final country = _countries.firstWhere(
      (c) => c.id == countryId,
      orElse: () => Country(name: 'Desconhecido'),
    );
    return country.name;
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(_errorMessage, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadData, child: const Text('Tentar Novamente')),
          ],
        ),
      );
    }

    if (_states.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Nenhum estado cadastrado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Toque no botão + para adicionar um estado', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _states.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final state = _states[index];
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.map, color: Colors.white),
          ),
          title: Text('${state.name} (${state.acronym})', style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text('País: ${_getCountryName(state.countryId)}'),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _addOrEditState(state);
                  break;
                case 'delete':
                  _deleteState(state, index);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Editar')),
              const PopupMenuItem(value: 'delete', child: Text('Excluir')),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: CustomFloatingButton(
        onPressed: () => _addOrEditState(),
      ),
    );
  }
}

class StateFormDialog extends StatefulWidget {
  final EntityState.State? state;
  final List<Country> countries;
  final VoidCallback onSaved;

  const StateFormDialog({
    super.key,
    this.state,
    required this.countries,
    required this.onSaved,
  });

  @override
  State<StateFormDialog> createState() => _StateFormDialogState();
}

class _StateFormDialogState extends State<StateFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _acronymController = TextEditingController();
  final StateService _stateService = StateService();
  
  Country? _selectedCountry;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      _nameController.text = widget.state!.name;
      _acronymController.text = widget.state!.acronym;
      _selectedCountry = widget.countries.firstWhere(
        (c) => c.id == widget.state!.countryId,
        orElse: () => widget.countries.first,
      );
    } else if (widget.countries.isNotEmpty) {
      _selectedCountry = widget.countries.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _acronymController.dispose();
    super.dispose();
  }

  Future<void> _saveState() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um país'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      EntityState.State? result;
      
      if (widget.state != null) {
        // Editando
        final updatedState = widget.state!.copyWith(
          name: _nameController.text.trim(),
          acronym: _acronymController.text.trim().toUpperCase(),
          countryId: _selectedCountry!.id!,
        );
        final success = await _stateService.updateState(updatedState);
        if (success) {
          result = updatedState;
        }
      } else {
        // Adicionando
        result = await _stateService.addState(
          name: _nameController.text.trim(),
          acronym: _acronymController.text.trim().toUpperCase(),
          countryId: _selectedCountry!.id!,
        );
      }

      if (result != null) {
        widget.onSaved();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.state != null ? 'Estado atualizado com sucesso' : 'Estado adicionado com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar estado'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar estado: $e'),
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
    return AlertDialog(
      title: Text(widget.state != null ? 'Editar Estado' : 'Adicionar Estado'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<Country>(
              value: _selectedCountry,
              decoration: const InputDecoration(
                labelText: 'País',
              ),
              items: widget.countries.map((country) {
                return DropdownMenuItem<Country>(
                  value: country,
                  child: Text(country.name),
                );
              }).toList(),
              onChanged: (Country? value) {
                setState(() {
                  _selectedCountry = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecione um país';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Estado',
                hintText: 'Digite o nome do estado',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nome do estado é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _acronymController,
              decoration: const InputDecoration(
                labelText: 'Sigla',
                hintText: 'Ex: SP, RJ, MG',
              ),
              maxLength: 2,
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Sigla é obrigatória';
                }
                if (value.trim().length != 2) {
                  return 'Sigla deve ter 2 caracteres';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveState,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.state != null ? 'Atualizar' : 'Adicionar'),
        ),
      ],
    );
  }
}
