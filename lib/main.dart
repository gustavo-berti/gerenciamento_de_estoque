import 'package:flutter/material.dart';
import 'package:gerenciamento_de_estoque/presentation/app.dart';
import 'package:gerenciamento_de_estoque/core/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.initializeDatabase();

  runApp(const App());
}
