import 'package:gerenciamento_de_estoque/domain/entities/address.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product_supplier.dart';

class Supplier {
  String name;
  String phoneNumber;
  String enterprise;
  String email;
  Address address;
  final List<ProductSupplier> products;
  Supplier({required this.name, required this.address, required this.email, required this.enterprise, required this.phoneNumber, required this.products});
}