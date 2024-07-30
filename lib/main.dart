import 'package:dango/views/expense_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './services/database_service.dart';

void main() {
  runApp(
    MultiProvider(
        providers: [
          Provider<DatabaseService>(create: (_) => DatabaseService()),
        ],
        child: const MaterialApp(
          home: MyApp(),
        )),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // use like this anywhere.
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("당고"),
      ),
      body: const Center(),
    );
  }
}
