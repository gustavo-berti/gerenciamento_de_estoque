import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/routes/routes.dart';
import 'package:gerenciamento_de_estoque/core/services/product_service.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product.dart';

class WidgetProductList extends StatefulWidget {
  const WidgetProductList({super.key});

  @override
  State<WidgetProductList> createState() => _WidgetProductListState();
}

class _WidgetProductListState extends State<WidgetProductList> {
  final ProductService _productService = ProductService();
  List<Map<String, dynamic>> _productsWithDetails = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await _productService.getProductsWithDetails();
      setState(() {
        _productsWithDetails = products;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar produtos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(int productId, String productName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir o produto "$productName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await _productService.deleteProduct(productId);
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Produto excluído com sucesso'),
                backgroundColor: Colors.green,
              ),
            );
            _loadProducts();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erro ao excluir produto'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir produto: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _navigateToForm([Map<String, dynamic>? productData]) async {
    Product? product;
    if (productData != null) {
      product = Product(
        id: productData['id'] as int,
        name: productData['name'] as String,
        amount: productData['amount'] as int,
        purchasePrice: (productData['purchase_price'] as num?)?.toDouble() ?? 0.0,
        sellPrice: (productData['sell_price'] as num?)?.toDouble() ?? 0.0,
        categoryId: productData['category_id'] as int,
        supplierId: productData['supplier_id'] as int,
      );
    }

    final result = await Navigator.pushNamed(
      context,
      Routes.productForm,
      arguments: product,
    );

    if (result == true) {
      _loadProducts();
    }
  }

  Color _getStockColor(int amount) {
    if (amount == 0) return Colors.red;
    if (amount <= 10) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProducts,
              child: _productsWithDetails.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum produto encontrado',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _productsWithDetails.length,
                      itemBuilder: (context, index) {
                        final product = _productsWithDetails[index];
                        final amount = product['amount'] as int;
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getStockColor(amount),
                              child: Text(
                                amount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              product['name'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Categoria: ${product['category_name']}'),
                                Text('Fornecedor: ${product['supplier_name']}'),
                                Text(
                                  'Estoque: $amount',
                                  style: TextStyle(
                                    color: _getStockColor(amount),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Preço Compra: R\$ ${(product['purchase_price'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Preço Venda: R\$ ${(product['sell_price'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _navigateToForm(product);
                                } else if (value == 'delete') {
                                  _deleteProduct(
                                    product['id'] as int,
                                    product['name'] as String,
                                  );
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('Editar'),
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Icon(Icons.delete, color: Colors.red),
                                    title: Text('Excluir', style: TextStyle(color: Colors.red)),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => _navigateToForm(product),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}