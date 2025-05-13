import 'package:gerenciamento_de_estoque/entity/product.dart';
import 'package:gerenciamento_de_estoque/config/enum.dart';
 
class StockMovement {
  Product product;
  int amount;
  DateTime date;
  Type type;
  StockMovement({required this.product, required this.amount, required this.date, required this.type});
}
