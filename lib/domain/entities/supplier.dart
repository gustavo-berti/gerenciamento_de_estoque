import 'package:gerenciamento_de_estoque/domain/entities/address.dart';

class Supplier {
  String name;
  String phoneNumber;
  String enterprise;
  String email;
  Address address;
  Supplier({required this.name, required this.address, required this.email, required this.enterprise, required this.phoneNumber});
}