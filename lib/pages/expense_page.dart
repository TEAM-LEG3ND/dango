import 'package:dango/views/widgets/app_bar_base.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../views/expense_view.dart';

class ExpensePage extends StatefulWidget {
  final ObjectId groupId; // Ensure this is the parameter name
  final String groupName;

  const ExpensePage(
      {super.key, required this.groupId, required this.groupName});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBase(
        leading: const Row(
          children: [
            SizedBox(width: 8),
            Icon(Icons.arrow_back),
            SizedBox(width: 4),
            Text(
              '뒤로',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        title: widget.groupName,
        action: const Row(
          children: [
            SizedBox(width: 4),
            Text(
              '정산',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward),
          ],
        ),
        onLeadingTap: () {
          Navigator.pop(
              context); // This will navigate back to the previous screen
        },
      ),
      body: ExpenseView(groupId: widget.groupId, groupName: widget.groupName),
    );
  }
}
