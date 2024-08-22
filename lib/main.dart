import 'package:dango/viewmodels/expense_viewmodel.dart';
import 'package:dango/views/expense_view.dart';
import 'package:dango/views/widgets/app_bar_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './services/database_service.dart';
import './services/navigation_service.dart';

void main() {
  final navigationService = NavigationService();

  runApp(
    MultiProvider(
        providers: [
          Provider<DatabaseService>(create: (_) => DatabaseService()),
          Provider<NavigationService>(create: (_) => NavigationService()),
          ChangeNotifierProvider<ExpenseViewModel>(
              create: (context) => ExpenseViewModel(Provider.of<DatabaseService>(context, listen: false)),
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigationService.navigatorKey,
          routes: {
            '/expense': (context) => const ExpenseView(),
          },
          home: const MyApp(),
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
    final navigationService = Provider.of<NavigationService>(context);

    return const Scaffold(
      appBar: AppBarBase(),
      body: ExpenseView(),
    );
  }
}
