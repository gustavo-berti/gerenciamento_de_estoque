import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/services/city_service.dart';
import 'package:gerenciamento_de_estoque/core/services/state_service.dart';
import 'package:gerenciamento_de_estoque/core/services/country_service.dart';
import 'package:gerenciamento_de_estoque/domain/entities/city.dart';
import 'package:gerenciamento_de_estoque/domain/entities/state.dart' as EntityState;
import 'package:gerenciamento_de_estoque/domain/entities/country.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_floating_button.dart';

class CityListScreen extends StatefulWidget {
  const CityListScreen({super.key});

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  final CityService _cityService = CityService();
  final StateService _stateService = StateService();
  final CountryService _countryService = CountryService();
  
  List<City> _cities = [];
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
      final [cities, states, countries] = await Future.wait([
        _cityService.getAllCities(),
        _stateService.getAllStates(),
        _countryService.getAllCountries(),
      ]);
      
      setState(() {
        _cities = cities as List<City>;
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

  Future<void> _deleteCity(City city, int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja excluir a cidade "${city.name}"?'),
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
        final success = await _cityService.deleteCity(city.id!);
        if (success) {
          setState(() {
            _cities.removeAt(index);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cidade "${city.name}" excluída com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao excluir cidade'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir cidade: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addOrEditCity([City? city]) {
    showDialog(
      context: context,
      builder: (context) => CityFormDialog(
        city: city,
        states: _states,
        countries: _countries,
        onSaved: _loadData,
      ),
    );
  }

  String _getStateInfo(int stateId) {
    final state = _states.firstWhere(
      (s) => s.id == stateId,
      orElse: () => EntityState.State(name: 'Desconhecido', acronym: '--', countryId: 0),
    );
    final country = _countries.firstWhere(
      (c) => c.id == state.countryId,
      orElse: () => Country(name: 'Desconhecido'),
    );
    return '${state.name} (${state.acronym}) - ${country.name}';
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

    if (_cities.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_city, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Nenhuma cidade cadastrada', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Toque no botão + para adicionar uma cidade', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _cities.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final city = _cities[index];
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.location_city, color: Colors.white),
          ),
          title: Text(city.name, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(_getStateInfo(city.stateId)),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _addOrEditCity(city);
                  break;
                case 'delete':
                  _deleteCity(city, index);
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
        onPressed: () => _addOrEditCity(),
      ),
    );
  }
}

class CityFormDialog extends StatefulWidget {
  final City? city;
  final List<EntityState.State> states;
  final List<Country> countries;
  final VoidCallback onSaved;

  const CityFormDialog({
    super.key,
    this.city,
    required this.states,
    required this.countries,
    required this.onSaved,
  });

  @override
  State<CityFormDialog> createState() => _CityFormDialogState();
}

class _CityFormDialogState extends State<CityFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final CityService _cityService = CityService();
  
  Country? _selectedCountry;
  EntityState.State? _selectedState;
  List<EntityState.State> _filteredStates = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.city != null) {
      _nameController.text = widget.city!.name;
      _selectedState = widget.states.firstWhere(
        (s) => s.id == widget.city!.stateId,
        orElse: () => widget.states.first,
      );
      _selectedCountry = widget.countries.firstWhere(
        (c) => c.id == _selectedState!.countryId,
        orElse: () => widget.countries.first,
      );
      _filterStates();
    } else if (widget.countries.isNotEmpty) {
      _selectedCountry = widget.countries.first;
      _filterStates();
    }
  }

  void _filterStates() {
    if (_selectedCountry != null) {
      setState(() {
        _filteredStates = widget.states
            .where((state) => state.countryId == _selectedCountry!.id)
            .toList();
        
        // Se o estado selecionado não está na lista filtrada, limpar seleção
        if (_selectedState != null && 
            !_filteredStates.any((s) => s.id == _selectedState!.id)) {
          _selectedState = null;
        }
        
        // Se não há estado selecionado e há estados disponíveis, selecionar o primeiro
        if (_selectedState == null && _filteredStates.isNotEmpty) {
          _selectedState = _filteredStates.first;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um estado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      City? result;
      
      if (widget.city != null) {
        // Editando
        final updatedCity = widget.city!.copyWith(
          name: _nameController.text.trim(),
          stateId: _selectedState!.id!,
        );
        final success = await _cityService.updateCity(updatedCity);
        if (success) {
          result = updatedCity;
        }
      } else {
        // Adicionando
        result = await _cityService.addCity(
          name: _nameController.text.trim(),
          stateId: _selectedState!.id!,
        );
      }

      if (result != null) {
        widget.onSaved();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.city != null ? 'Cidade atualizada com sucesso' : 'Cidade adicionada com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar cidade'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar cidade: $e'),
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
      title: Text(widget.city != null ? 'Editar Cidade' : 'Adicionar Cidade'),
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
                  _selectedState = null;
                });
                _filterStates();
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecione um país';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<EntityState.State>(
              value: _selectedState,
              decoration: const InputDecoration(
                labelText: 'Estado',
              ),
              items: _filteredStates.map((state) {
                return DropdownMenuItem<EntityState.State>(
                  value: state,
                  child: Text('${state.name} (${state.acronym})'),
                );
              }).toList(),
              onChanged: (EntityState.State? value) {
                setState(() {
                  _selectedState = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecione um estado';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome da Cidade',
                hintText: 'Digite o nome da cidade',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nome da cidade é obrigatório';
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
          onPressed: _isLoading ? null : _saveCity,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.city != null ? 'Atualizar' : 'Adicionar'),
        ),
      ],
    );
  }
}
