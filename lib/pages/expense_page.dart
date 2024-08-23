import 'package:dango/views/widgets/app_bar_base.dart';
import 'package:flutter/material.dart';

import '../views/expense_view.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarBase(
        leadingText: '뒤로',
        title: '당고',
        actionText: '정산',
      ),
      body: ExpenseView(),
    );
  }
}
