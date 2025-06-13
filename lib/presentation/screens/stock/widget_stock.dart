import 'package:flutter/material.dart';
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
  List<DropdownMenuItem> items = [
    DropdownMenuItem(value: null, child: Text("Selecione um produto")),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScafolld(
      title: "Estoque",
      body: Center(
        child: ListView.builder(
          key: _listKey,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                items[index].value?.toString() ?? "Produto ${index + 1}",
              ),
              trailing: Text("1", style: TextStyle(fontSize: 15)),
            );
          },
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        onPressed: () async {
          final result = await showModalBottomSheet(
            context: context,
            builder:
                (context) => Padding(
                  padding: EdgeInsets.all(5),
                  child: WidgetMovementForm(),
                ),
          );
          setState(() {
            if (result == true) {
              setState(() {});
            }
          });
        },
      ),
    );
  }
}
