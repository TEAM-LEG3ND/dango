import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dango/viewmodels/expense_viewmodel.dart';
import 'package:dango/views/expense_view.dart';

class ListViewScreen extends StatelessWidget {
  const ListViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("List View Screen"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.expenses.length, // Use actual data length
              itemBuilder: (context, index) {
                final expense = viewModel.expenses[index];
                return ListTile(
                  title: Text(expense.description),
                  subtitle:
                      Text('Amount: \$${expense.amount.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpenseView(expense: expense),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExpenseView(),
                  ),
                );
              },
              child: const Text('Go to Expense View'),
            ),
          ),
        ],
      ),
    );
  }
}
