import 'package:gerenciamento_de_estoque/domain/entities/product.dart';
import 'package:gerenciamento_de_estoque/domain/entities/stockMovement.dart';
import 'package:gerenciamento_de_estoque/core/enums/movement_type.dart';

class Stock {
  List<Product> products;
  Stock({required this.products});
  
  void updateStock(StockMovement stockMovement){
    switch(stockMovement.type){
      case MovementType.entry:
        
        break;

      case MovementType.exit:

        break;
    }
  }
}