import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/domain/entities/database.dart';
import 'package:gerenciamento_de_estoque/presentation/screens/movement/widget_movement_form.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_floating_button.dart';
import 'package:gerenciamento_de_estoque/presentation/widgets/custom_scaffold.dart';

class WidgetStock extends StatefulWidget {
  const WidgetStock({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetStock();
}

class _WidgetStock extends State<WidgetStock> {
  final _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CustomScafolld(
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
      floatingActionButton: CustomFloatingButton(
        onPressed: () {
          setState(() {
            showModalBottomSheet(context: context, builder: (context) => Padding(padding: EdgeInsets.all(5),child: WidgetMovementForm(),),);
          });
        },
      ),
    );
  }
}
