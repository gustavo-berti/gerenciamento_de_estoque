import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/services/stock_service.dart';
import 'package:gerenciamento_de_estoque/core/services/country_service.dart';
import 'package:gerenciamento_de_estoque/core/services/state_service.dart';
import 'package:gerenciamento_de_estoque/core/services/city_service.dart';
import 'package:gerenciamento_de_estoque/domain/entities/supplier.dart';
import 'package:gerenciamento_de_estoque/domain/entities/country.dart';
import 'package:gerenciamento_de_estoque/domain/entities/state.dart' as EntityState;
import 'package:gerenciamento_de_estoque/domain/entities/city.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_save_cancel_buttons.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_scaffold.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_text_form_field.dart';

class WidgetSupplierForm extends StatefulWidget {
  final Supplier? supplier; // Para edição

  const WidgetSupplierForm({super.key, this.supplier});

  @override
  State<StatefulWidget> createState() => _WidgetSupplierFormState();
}

class _WidgetSupplierFormState extends State<WidgetSupplierForm> {
  final _formKey = GlobalKey<FormState>();
  final StockService _stockService = StockService();
  final CountryService _countryService = CountryService();
  final StateService _stateService = StateService();
  final CityService _cityService = CityService();
  
  // Controllers para os campos
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _enterpriseController;
  late TextEditingController _emailController;
  late TextEditingController _streetController;
  late TextEditingController _numberController;
  late TextEditingController _addressLine2Controller;

  // Dados para dropdowns
  List<Country> _countries = [];
  List<EntityState.State> _states = [];
  List<City> _cities = [];
  
  // Seleções atuais
  Country? _selectedCountry;
  EntityState.State? _selectedState;
  City? _selectedCity;

  bool _isLoading = false;
  bool _isEditing = false;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.supplier != null;
    
    // Inicializar controllers
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _enterpriseController = TextEditingController();
    _emailController = TextEditingController();
    _streetController = TextEditingController();
    _numberController = TextEditingController();
    _addressLine2Controller = TextEditingController();

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingData = true;
    });

    try {
      final [countries, states, cities] = await Future.wait([
        _countryService.getAllCountries(),
        _stateService.getAllStates(),
        _cityService.getAllCities(),
      ]);

      setState(() {
        _countries = countries as List<Country>;
        _states = states as List<EntityState.State>;
        _cities = cities as List<City>;
        _isLoadingData = false;
      });

      // Se estiver editando, preencher os campos
      if (_isEditing) {
        _fillFormForEditing();
      } else {
        // Valores padrão - selecionar Brasil se existir
        final brasilCountry = _countries.firstWhere(
          (c) => c.name.toLowerCase() == 'brasil',
          orElse: () => _countries.isNotEmpty ? _countries.first : Country(name: 'Indefinido'),
        );
        if (brasilCountry.name != 'Indefinido') {
          _selectedCountry = brasilCountry;
          _filterStates();
        }
      }
    } catch (e) {
      setState(() {
        _isLoadingData = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar dados: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _fillFormForEditing() {
    final supplier = widget.supplier!;
    _nameController.text = supplier.name;
    _phoneController.text = supplier.phoneNumber;
    _enterpriseController.text = supplier.enterprise;
    _emailController.text = supplier.email;
    _streetController.text = supplier.address.street;
    _numberController.text = supplier.address.number;
    _addressLine2Controller.text = supplier.address.addressLine2;

    // Buscar cidade, estado e país pelos nomes
    _selectedCity = _cities.firstWhere(
      (c) => c.name == supplier.address.city.name,
      orElse: () => City(name: '', stateId: 0),
    );
    
    if (_selectedCity != null && _selectedCity!.stateId > 0) {
      _selectedState = _states.firstWhere(
        (s) => s.id == _selectedCity!.stateId,
        orElse: () => EntityState.State(name: '', acronym: '', countryId: 0),
      );
      
      if (_selectedState != null && _selectedState!.countryId > 0) {
        _selectedCountry = _countries.firstWhere(
          (c) => c.id == _selectedState!.countryId,
          orElse: () => Country(name: ''),
        );
      }
    }
  }

  void _filterStates() {
    setState(() {
      // Limpar estado e cidade se o país mudou
      if (_selectedState != null && _selectedCountry != null) {
        final stateExists = _filteredStates.any((s) => s.id == _selectedState!.id);
        if (!stateExists) {
          _selectedState = null;
          _selectedCity = null;
        }
      }
    });
    _filterCities();
  }

  void _filterCities() {
    setState(() {
      // Limpar cidade se o estado mudou
      if (_selectedCity != null && _selectedState != null) {
        final cityExists = _filteredCities.any((c) => c.id == _selectedCity!.id);
        if (!cityExists) {
          _selectedCity = null;
        }
      }
    });
  }

  List<EntityState.State> get _filteredStates {
    if (_selectedCountry == null) return [];
    return _states.where((state) => state.countryId == _selectedCountry!.id).toList();
  }

  List<City> get _filteredCities {
    if (_selectedState == null) return [];
    return _cities.where((city) => city.stateId == _selectedState!.id).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _enterpriseController.dispose();
    _emailController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _addressLine2Controller.dispose();
    super.dispose();
  }

  Future<void> _saveSupplier() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validar seleções de endereço
    if (_selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um país'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um estado'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma cidade'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Criar novo fornecedor com dados selecionados
      final supplier = await _stockService.addSupplier(
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        enterprise: _enterpriseController.text.trim(),
        email: _emailController.text.trim(),
        street: _streetController.text.trim(),
        number: _numberController.text.trim(),
        addressLine2: _addressLine2Controller.text.trim(),
        cityName: _selectedCity!.name,
        stateName: _selectedState!.name,
        stateAcronym: _selectedState!.acronym,
        countryName: _selectedCountry!.name,
      );

      if (supplier != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fornecedor "${supplier.name}" salvo com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar fornecedor. Verifique se o email já existe.'),
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

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email é obrigatório';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScafolld(
      title: _isEditing ? "Editar Fornecedor" : "Cadastrar Fornecedor",
      body: _isLoadingData || _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Seção: Dados Básicos
                  _buildSectionTitle('Dados Básicos'),
                  CustomTextFormField(
                    controller: _nameController,
                    label: "Nome do Fornecedor",
                    hint: "Digite o nome do fornecedor",
                    validator: (value) => _validateRequired(value, 'Nome'),
                  ),
                  CustomTextFormField(
                    controller: _enterpriseController,
                    label: "Empresa",
                    hint: "Digite o nome da empresa",
                    validator: (value) => _validateRequired(value, 'Empresa'),
                  ),
                  CustomTextFormField(
                    controller: _emailController,
                    label: "Email",
                    hint: "Digite o email do fornecedor",
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  CustomTextFormField(
                    controller: _phoneController,
                    label: "Telefone",
                    hint: "Digite o telefone (opcional)",
                    keyboardType: TextInputType.phone,
                    useDefaultValidator: false,
                  ),
                  const SizedBox(height: 24),

                  // Seção: Endereço
                  _buildSectionTitle('Endereço'),
                  
                  // Dropdown País
                  DropdownButtonFormField<Country>(
                    value: _selectedCountry,
                    decoration: const InputDecoration(
                      labelText: 'País',
                      border: OutlineInputBorder(),
                    ),
                    items: _countries.map((country) {
                      return DropdownMenuItem<Country>(
                        value: country,
                        child: Text(country.name),
                      );
                    }).toList(),
                    onChanged: (Country? value) {
                      setState(() {
                        _selectedCountry = value;
                        _selectedState = null;
                        _selectedCity = null;
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
                  
                  // Dropdown Estado
                  DropdownButtonFormField<EntityState.State>(
                    value: _selectedState,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
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
                        _selectedCity = null;
                      });
                      _filterCities();
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione um estado';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdown Cidade
                  DropdownButtonFormField<City>(
                    value: _selectedCity,
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                      border: OutlineInputBorder(),
                    ),
                    items: _filteredCities.map((city) {
                      return DropdownMenuItem<City>(
                        value: city,
                        child: Text(city.name),
                      );
                    }).toList(),
                    onChanged: (City? value) {
                      setState(() {
                        _selectedCity = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione uma cidade';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  CustomTextFormField(
                    controller: _streetController,
                    label: "Rua/Avenida",
                    hint: "Digite a rua ou avenida",
                    validator: (value) => _validateRequired(value, 'Rua'),
                  ),
                  CustomTextFormField(
                    controller: _numberController,
                    label: "Número",
                    hint: "Digite o número",
                    useDefaultValidator: false,
                  ),
                  CustomTextFormField(
                    controller: _addressLine2Controller,
                    label: "Complemento",
                    hint: "Digite o complemento (opcional)",
                    useDefaultValidator: false,
                  ),
                  const SizedBox(height: 32),

                  // Botões
                  CustomSaveCancelButtons(
                    context: context,
                    function: _saveSupplier,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
