import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/core/services/stock_service.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product.dart';
import 'package:gerenciamento_de_estoque/domain/entities/stock_movement.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/stock/widget_movement_form.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_floating_button.dart';

class WidgetStock extends StatefulWidget {
  const WidgetStock({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetStock();
}

class _WidgetStock extends State<WidgetStock> {
  final StockService _stockService = StockService();
  List<Product> _products = [];
  List<StockMovement> _recentMovements = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final products = await _stockService.getAllProducts();
      final movements = await _stockService.getAllMovements();

      setState(() {
        _products = products;
        _recentMovements =
            movements.take(10).toList(); // Últimas 10 movimentações
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar dados: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildStockTab() {
    if (_products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nenhum produto no estoque',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Adicione produtos para visualizar o estoque',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          final stockStatus = _getStockStatus(product.amount);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: stockStatus.color,
                child: Text(
                  product.amount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preço de Venda: R\$ ${product.sellPrice.toStringAsFixed(2)}',
                  ),
                  Text(
                    'Preço de Compra: R\$ ${product.purchasePrice.toStringAsFixed(2)}',
                  ),
                  Text(
                    'Status: ${stockStatus.text}',
                    style: TextStyle(
                      color: stockStatus.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${product.amount}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: stockStatus.color,
                    ),
                  ),
                  const Text('unidades', style: TextStyle(fontSize: 12)),
                ],
              ),
              onTap: () => _showProductDetails(product),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovementsTab() {
    if (_recentMovements.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nenhuma movimentação registrada',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'As movimentações aparecerão aqui',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        itemCount: _recentMovements.length,
        itemBuilder: (context, index) {
          final movement = _recentMovements[index];
          final isEntry = movement.type.toString() == 'MovementType.entry';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isEntry ? Colors.green : Colors.red,
                child: Icon(
                  isEntry ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.white,
                ),
              ),
              title: Text(
                movement.product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${isEntry ? "Entrada" : "Saída"}: ${movement.amount} unidades',
                  ),
                  Text(
                    'Data: ${_formatDate(movement.date)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: Text(
                '${isEntry ? "+" : "-"}${movement.amount}',
                style: TextStyle(
                  color: isEntry ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  StockStatus _getStockStatus(int amount) {
    if (amount == 0) {
      return StockStatus('Sem estoque', Colors.red);
    } else if (amount <= 5) {
      return StockStatus('Estoque baixo', Colors.orange);
    } else if (amount <= 20) {
      return StockStatus('Estoque adequado', Colors.blue);
    } else {
      return StockStatus('Estoque alto', Colors.green);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(product.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantidade em estoque: ${product.amount}'),
                Text(
                  'Preço de compra: R\$ ${product.purchasePrice.toStringAsFixed(2)}',
                ),
                Text(
                  'Preço de venda: R\$ ${product.sellPrice.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 10),
                Text(_getStockStatus(product.amount).text),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showMovementForm();
                },
                child: const Text('Nova Movimentação'),
              ),
            ],
          ),
    );
  }

  Future<void> _showMovementForm() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: const SizedBox(height: 600, child: WidgetMovementForm()),
          ),
    );

    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.inventory), text: 'Estoque'),
            Tab(icon: Icon(Icons.history), text: 'Movimentações'),
          ],
        ),
        body: TabBarView(children: [_buildStockTab(), _buildMovementsTab()]),
        floatingActionButton: CustomFloatingButton(
          onPressed: () => _showMovementForm(),
        ),
      ),
    );
  }
}

class StockStatus {
  final String text;
  final Color color;

  StockStatus(this.text, this.color);
}
