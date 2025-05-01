import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/config/function.dart';
import 'package:gerenciamento_de_estoque/database/database.dart';

class WidgetStock extends StatefulWidget {
  const WidgetStock({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetStock();
}

class _WidgetStock extends State<WidgetStock> {
  final _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return createScaffold(
      title: "Estoque",
      body: Center(
        child: ListView.builder(
          key: _listKey,
          itemCount:
              Database.stock.products.isEmpty
                  ? 0
                  : Database.stock.products.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(Database.stock.products[index].name),
              trailing: Text(
                "${Database.stock.products[index].amount}",
                style: TextStyle(fontSize: 15),
              ),
            );
          },
        ),
      ),
      floatingActionButton: createFloatingActionButton(
        onPressed: () {
          setState(() {
            //TODO Aba para adicionar e remover do estoque
          });
        },
      ),
    );
  }
}
