import 'package:flutter/material.dart';

Widget createScaffold({
  required Widget body,
  String title = "Gerenciameno de Estoque",
  FloatingActionButton? floatingActionButton,
}) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      backgroundColor: const Color.fromRGBO(187, 222, 251, 1),
      centerTitle: true,
    ),
    body: body,
    floatingActionButton: floatingActionButton,
  );
}

Widget newButton({required String text, required VoidCallback function, size}) {
  return ElevatedButton(
    onPressed: function,
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
        const Color.fromRGBO(187, 222, 251, 1),
      ),
      fixedSize:
          size == null
              ? WidgetStateProperty.all(Size.fromWidth(280))
              : WidgetStateProperty.all(Size.fromWidth(size)),
    ),
    child: Text(text, style: TextStyle(color: Colors.black)),
  );
}

createFloatingActionButton({required Function() onPressed}) {
  return FloatingActionButton(
    onPressed: onPressed,
    backgroundColor: const Color.fromRGBO(187, 222, 251, 1),
    foregroundColor: Colors.black,
    shape: CircleBorder(),
    child: Icon(Icons.add),
  );
}

Widget createTextFormField({
  required String label,
  required String hint,
  bool obscure = false,
  onChanged,
  validator,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    child: TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        labelText: label,
        hintText: hint,
      ),
      obscureText: obscure,
      onChanged: onChanged,
      validator: validator,
    ),
  );
}

Widget createDropdownFormField({
  required label,
  required hint,
  required List<DropdownMenuItem> items,
  onChanged,
  validator,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    child: DropdownButtonFormField(
      items: items,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        labelText: label,
        hintText: hint,
      ),
      onChanged: onChanged,
      validator: validator,
    ),
  );
}

Widget createSaveCancelButton({required context, required function}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      newButton(text: "Salvar", function: function, size: 100),
      Padding(padding: EdgeInsets.all(2)),
      newButton(
        text: "Cancelar",
        function: () {
          Navigator.pop(context);
        },
        size: 110,
      ),
    ],
  );
}
