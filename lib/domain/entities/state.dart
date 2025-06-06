import 'package:gerenciamento_de_estoque/domain/entities/country.dart';

class State {
  Country country;
  String name;
  String acronym;

  State({required this.country, required this.acronym, required this.name});
}
