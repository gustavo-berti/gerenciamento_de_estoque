import 'package:gerenciamento_de_estoque/data/dao/product_dao.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product.dart';

class ProductService {
  final ProductDao _productDao = ProductDao();

  Future<List<Product>> getAllProducts() async {
    try {
      return await _productDao.getAllProducts();
    } catch (e) {
      print('Erro ao buscar produtos: $e');
      rethrow;
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      return await _productDao.getProductById(id);
    } catch (e) {
      print('Erro ao buscar produto por ID: $e');
      rethrow;
    }
  }

  Future<Product?> getProductByName(String name) async {
    try {
      return await _productDao.getProductByName(name);
    } catch (e) {
      print('Erro ao buscar produto por nome: $e');
      rethrow;
    }
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      return await _productDao.getProductsByCategory(categoryId);
    } catch (e) {
      print('Erro ao buscar produtos por categoria: $e');
      rethrow;
    }
  }

  Future<List<Product>> getProductsBySupplier(int supplierId) async {
    try {
      return await _productDao.getProductsBySupplier(supplierId);
    } catch (e) {
      print('Erro ao buscar produtos por fornecedor: $e');
      rethrow;
    }
  }

  Future<List<Product>> getLowStockProducts({int threshold = 10}) async {
    try {
      return await _productDao.getLowStockProducts(threshold);
    } catch (e) {
      print('Erro ao buscar produtos com estoque baixo: $e');
      rethrow;
    }
  }

  Future<Product> addProduct(Product product) async {
    try {
      // Validações
      final validationResult = _validateProduct(product);
      if (validationResult != null) {
        throw Exception(validationResult);
      }

      // Verifica se já existe produto com o mesmo nome
      final existingByName = await _productDao.getProductByName(product.name);
      if (existingByName != null) {
        throw Exception('Já existe um produto com este nome');
      }

      final id = await _productDao.insertProduct(product);
      return product.copyWith(id: id);
    } catch (e) {
      print('Erro ao adicionar produto: $e');
      rethrow;
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    try {
      // Validações
      final validationResult = _validateProduct(product);
      if (validationResult != null) {
        throw Exception(validationResult);
      }

      // Verifica se existe
      final existing = await _productDao.getProductById(id);
      if (existing == null) {
        throw Exception('Produto não encontrado');
      }

      // Verifica se não existe outro produto com o mesmo nome
      final existingByName = await _productDao.getProductByName(product.name);
      if (existingByName != null && existingByName.id != id) {
        throw Exception('Já existe um produto com este nome');
      }

      await _productDao.updateProduct(id, product);
      return product.copyWith(id: id);
    } catch (e) {
      print('Erro ao atualizar produto: $e');
      rethrow;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final existing = await _productDao.getProductById(id);
      if (existing == null) {
        throw Exception('Produto não encontrado');
      }

      final result = await _productDao.deleteProduct(id);
      return result > 0;
    } catch (e) {
      print('Erro ao deletar produto: $e');
      rethrow;
    }
  }

  Future<Product> updateProductStock(int id, int newAmount) async {
    try {
      if (newAmount < 0) {
        throw Exception('Quantidade não pode ser negativa');
      }

      final existing = await _productDao.getProductById(id);
      if (existing == null) {
        throw Exception('Produto não encontrado');
      }

      await _productDao.updateProductStock(id, newAmount);
      return existing.copyWith(amount: newAmount);
    } catch (e) {
      print('Erro ao atualizar estoque do produto: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getProductsWithDetails() async {
    try {
      return await _productDao.getProductsWithDetails();
    } catch (e) {
      print('Erro ao buscar produtos com detalhes: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getProductWithDetailsById(int id) async {
    try {
      return await _productDao.getProductWithDetailsById(id);
    } catch (e) {
      print('Erro ao buscar produto com detalhes por ID: $e');
      rethrow;
    }
  }

  String? _validateProduct(Product product) {
    if (product.name.trim().isEmpty) {
      return 'Nome do produto é obrigatório';
    }

    if (product.name.trim().length < 2) {
      return 'Nome do produto deve ter pelo menos 2 caracteres';
    }

    if (product.amount < 0) {
      return 'Quantidade não pode ser negativa';
    }

    if (product.purchasePrice < 0) {
      return 'Preço de compra não pode ser negativo';
    }

    if (product.sellPrice < 0) {
      return 'Preço de venda não pode ser negativo';
    }

    if (product.sellPrice < product.purchasePrice) {
      return 'Preço de venda não pode ser menor que o preço de compra';
    }

    if (product.categoryId <= 0) {
      return 'Categoria é obrigatória';
    }

    if (product.supplierId <= 0) {
      return 'Fornecedor é obrigatório';
    }

    return null;
  }

  Future<bool> productNameExists(String name, {int? excludeId}) async {
    try {
      final existing = await _productDao.getProductByName(name);
      if (existing == null) return false;
      
      if (excludeId != null && existing.id == excludeId) {
        return false;
      }
      
      return true;
    } catch (e) {
      print('Erro ao verificar se nome do produto existe: $e');
      return false;
    }
  }
}
