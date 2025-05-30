import 'package:gerenciamento_de_estoque/domain/entities/product.dart';
import 'package:gerenciamento_de_estoque/domain/entities/stock_movement.dart';
import 'package:gerenciamento_de_estoque/core/enums/movement_type.dart';

class Stock {
  List<Product> products;
  Stock({required this.products});
  
  void updateStock(StockMovement stockMovement){
    switch(stockMovement.type){
      case MovementType.entry:
        for(int i = 0; i<products.length; i++){
          if(products[i] == stockMovement.product){
            products[i].amount += stockMovement.amount;
          }
        }
        break;
      case MovementType.exit:
        for(int i = 0; i<products.length; i++){
          if(products[i] == stockMovement.product){
            products[i].amount -= stockMovement.amount;
          }
        }
        break;
    }
  }
}