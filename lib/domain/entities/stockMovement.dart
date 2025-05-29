import 'package:gerenciamento_de_estoque/domain/entities/product.dart';
import 'package:gerenciamento_de_estoque/core/enums/movement_type.dart';
 
class StockMovement {
  Product product;
  int amount;
  DateTime date;
  MovementType type;
  StockMovement({required this.product, required this.amount, required this.date, required this.type});
}
