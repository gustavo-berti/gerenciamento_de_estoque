import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/services/country_service.dart';
import 'package:gerenciamento_de_estoque/domain/entities/country.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_floating_button.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  final CountryService _countryService = CountryService();
  List<Country> _countries = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final countries = await _countryService.getAllCountries();
      setState(() {
        _countries = countries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar países: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCountry(Country country, int index) async {
    final canDelete = await _countryService.canDeleteCountry(country.id!);
    if (!canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não é possível excluir este país pois possui estados cadastrados'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja excluir o país "${country.name}"?'),
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
        final success = await _countryService.deleteCountry(country.id!);
        if (success) {
          setState(() {
            _countries.removeAt(index);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('País "${country.name}" excluído com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao excluir país'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir país: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addOrEditCountry([Country? country]) {
    showDialog(
      context: context,
      builder: (context) => CountryFormDialog(
        country: country,
        onSaved: _loadCountries,
      ),
    );
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
            ElevatedButton(onPressed: _loadCountries, child: const Text('Tentar Novamente')),
          ],
        ),
      );
    }

    if (_countries.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.public, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Nenhum país cadastrado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Toque no botão + para adicionar um país', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _countries.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final country = _countries[index];
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.public, color: Colors.white),
          ),
          title: Text(country.name, style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _addOrEditCountry(country);
                  break;
                case 'delete':
                  _deleteCountry(country, index);
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
        onPressed: () => _addOrEditCountry(),
      ),
    );
  }
}

class CountryFormDialog extends StatefulWidget {
  final Country? country;
  final VoidCallback onSaved;

  const CountryFormDialog({
    super.key,
    this.country,
    required this.onSaved,
  });

  @override
  State<CountryFormDialog> createState() => _CountryFormDialogState();
}

class _CountryFormDialogState extends State<CountryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final CountryService _countryService = CountryService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.country != null) {
      _nameController.text = widget.country!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCountry() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Country? result;
      
      if (widget.country != null) {
        // Editando
        final updatedCountry = widget.country!.copyWith(name: _nameController.text.trim());
        final success = await _countryService.updateCountry(updatedCountry);
        if (success) {
          result = updatedCountry;
        }
      } else {
        // Adicionando
        result = await _countryService.addCountry(_nameController.text.trim());
      }

      if (result != null) {
        widget.onSaved();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.country != null ? 'País atualizado com sucesso' : 'País adicionado com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar país'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar país: $e'),
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
      title: Text(widget.country != null ? 'Editar País' : 'Adicionar País'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Nome do País',
            hintText: 'Digite o nome do país',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nome do país é obrigatório';
            }
            return null;
          },
          autofocus: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveCountry,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.country != null ? 'Atualizar' : 'Adicionar'),
        ),
      ],
    );
  }
}
