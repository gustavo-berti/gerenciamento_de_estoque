import 'package:gerenciamento_de_estoque/entity/product.dart';
import 'package:gerenciamento_de_estoque/entity/stockMovement.dart';
import 'package:gerenciamento_de_estoque/config/enum.dart';

class Stock {
  List<Product> products;
  Stock({required this.products});
  
  void updateStock(StockMovement stockMovement){
    switch(stockMovement.type){
      case Type.entry:
        
        break;

      case Type.exit:

        break;

      default:
        break;
    }
  }
}