import 'package:flutter/material.dart';

Widget createScaffold({
  required Widget body,
  FloatingActionButton? floatingActionButton,
}) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Gerenciamento de Estoque"),
      backgroundColor: const Color.fromRGBO(187, 222, 251, 1),
      centerTitle: true,
    ),
    body: body,
    floatingActionButton: floatingActionButton,
  );
}

Widget newButton({required String text, required VoidCallback function}) {
  return ElevatedButton(
    onPressed: function,
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
        const Color.fromRGBO(187, 222, 251, 1),
      ),
      fixedSize: WidgetStateProperty.all(Size.fromWidth(280)),
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
  required label,
  required hint,
  obscure = false,
  onChanged,
  validator,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
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
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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