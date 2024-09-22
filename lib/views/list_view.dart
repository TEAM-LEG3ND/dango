import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/expense_viewmodel.dart';
import '../pages/expense_page.dart';
import '../models/models.dart'; // Assuming your Group model is here

class GroupListView extends StatelessWidget {
  final bool isEditing;
  final List<Group> selectedGroups;
  final Function(Group, bool) onSelectGroup;

  const GroupListView({
    Key? key,
    required this.isEditing,
    required this.selectedGroups,
    required this.onSelectGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);

    return ListView.builder(
      itemCount: viewModel.groups.length,
      itemBuilder: (context, index) {
        final group = viewModel.groups[index];
        final isSelected = selectedGroups.contains(group);

        return ListTile(
          title: Text(group.name),
          trailing: isEditing
              ? Checkbox(
                  value: isSelected,
                  onChanged: (bool? value) {
                    onSelectGroup(group, value ?? false);
                  },
                )
              : null,
          onTap: isEditing
              ? () {
                  // Select or deselect the group
                  onSelectGroup(group, !isSelected);
                }
              : () {
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
    );
  }
}
