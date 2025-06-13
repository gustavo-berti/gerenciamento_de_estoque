import 'package:gerenciamento_de_estoque/domain/entities/product.dart';
import 'package:gerenciamento_de_estoque/domain/entities/supplier.dart';

class ProductSupplier {
  final int id;
  final Product product;
  final Supplier supplier;
  final double price;
  final double sellPrice;
  final bool isActive;

  ProductSupplier({
    required this.id,
    required this.product,
    required this.supplier,
    required this.price,
    required this.sellPrice,
    this.isActive = true,
  });
}
