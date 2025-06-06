import 'package:gerenciamento_de_estoque/domain/entities/city.dart';

class Address{
  City city;
  String street;
  String number;
  String addressLine2;

  Address({required this.addressLine2, required this.city, this.number = "", required this.street});
}