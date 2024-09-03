import 'package:dango/pages/expense_page.dart';
import 'package:dango/viewmodels/expense_viewmodel.dart';
import 'package:dango/views/list_view.dart';
import 'package:dango/views/widgets/app_bar_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);
    return Scaffold(
      appBar: AppBarBase(
        leading: const Icon(Icons.edit),
        title: 'Dango',
        action: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            if (viewModel.groups.isNotEmpty) {
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
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('No groups available to navigate to.')),
              );
            }
          },
        ),
        onLeadingTap: () {
          Navigator.pop(
              context); // This will navigate back to the previous screen
        },
      ),
      body: const GroupListView(),
    );
  }
}
