import 'package:dango/views/widgets/app_bar_base.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../views/expense_view.dart';

class ExpensePage extends StatefulWidget {
  final ObjectId groupId; // Ensure this is the parameter name
  final String groupName;

  const ExpensePage({Key? key, required this.groupId, required this.groupName})
      : super(key: key);

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBase(
        leadingText: '뒤로',
        title: widget.groupName,
        actionText: '정산',
        onLeadingTap: () {
          Navigator.pop(
              context); // This will navigate back to the previous screen
        },
      ),
      body: ExpenseView(groupId: widget.groupId, groupName: widget.groupName),
    );
  }
}
