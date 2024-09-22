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

        return GestureDetector(
          onTap: isEditing
              ? () {
                  // Select or deselect the group
                  onSelectGroup(group, !isSelected);
                }
              : () {
                  // Navigate to the ExpensePage
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
          child: Container(
            height: 60, // Fixed height for consistent row height
            decoration: BoxDecoration(
              color: isEditing
                  ? null
                  : const Color(0xffFFFFF1), // Lighter green when not editing
              border: const Border(
                top: BorderSide(
                  color: Color(0xffDEF2CF),
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Color(0xffDEF2CF),
                  width: 0.5,
                ),
              ),
            ),
            child: isEditing
                ? Row(
                    children: [
                      // Left Block (70% lighter green)
                      Expanded(
                        flex: 85,
                        child: Container(
                          color: const Color(0xffFFFFF1),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            group.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      // Right Block (30% darker green with checkbox)
                      Expanded(
                        flex: 15,
                        child: Container(
                          color: const Color(0xffDEF2CF),
                          alignment: Alignment.center, // Center the checkbox
                          child: Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              onSelectGroup(group, value ?? false);
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    alignment: Alignment.centerLeft, // Align text to the left
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      group.name,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
