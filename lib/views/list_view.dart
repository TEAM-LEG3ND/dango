import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/expense_viewmodel.dart';
import '../pages/expense_page.dart';

class ListViewScreen extends StatelessWidget {
  const ListViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Add a new group with a default name
              await viewModel.addNewGroup('New Group');

              // After adding the group, navigate to ExpensePage of the newly added group
              final newGroup = viewModel.groups.last;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpensePage(
                    groupId: newGroup.id,
                    groupName: newGroup.name,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // The ListView containing the groups
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.groups.length,
              itemBuilder: (context, index) {
                final group = viewModel.groups[index];
                return ListTile(
                  title: Text(group.name),
                  onTap: () {
                    // Navigate to ExpensePage and pass the group ID
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpensePage(
                          groupId: group.id,
                          groupName: group.name,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
