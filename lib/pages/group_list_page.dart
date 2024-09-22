import 'package:dango/models/models.dart';
import 'package:dango/pages/expense_page.dart';
import 'package:dango/viewmodels/expense_viewmodel.dart';
import 'package:dango/views/list_view.dart';
import 'package:dango/views/widgets/add_member_dialog.dart';
import 'package:dango/views/widgets/app_bar_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  bool _isEditing = false; // Track editing mode
  List<Group> _selectedGroups = []; // Track selected groups

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);

    return Scaffold(
      appBar: AppBarBase(
        leading: IconButton(
          icon: _isEditing ? const Text('완료') : const Icon(Icons.edit),
          onPressed: () {
            setState(() {
              _isEditing = !_isEditing; // Toggle editing mode
              if (!_isEditing) {
                _selectedGroups
                    .clear(); // Clear selections when exiting edit mode
              }
            });
          },
        ),
        title: const Text('List'),
        action: _isEditing
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.black),
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
              )
            : Container(
                decoration: const BoxDecoration(
                  color: Color(0xff95B47E), // Change this to your desired color
                  shape: BoxShape.rectangle, // Rounded corners
                ),
                child: IconButton(
                  icon: const Icon(Icons.add,
                      color: Color(0xff131313)), // Icon color
                  onPressed: () async {
                    await viewModel.addNewGroup('New Group');
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

                    // Show the AddMemberDialog and wait for the result
                    bool? memberCreated = await showDialog(
                      context: context,
                      builder: (context) =>
                          AddMemberDialog(groupId: newGroup.id),
                    );

                    // If no member was created, cancel creating the new group
                    if (memberCreated == null || !memberCreated) {
                      Navigator.pop(context);
                      viewModel.removeGroup(newGroup);
                      return; // Exit the method
                    }
                  },
                ),
              ),
        onLeadingTap: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Container(
            height: 1, // Height of the line
            color: Colors.black, // Line color
            margin:
                const EdgeInsets.symmetric(horizontal: 50), // Centered margins
          ),
          Expanded(
            child: GroupListView(
              isEditing: _isEditing,
              selectedGroups: _selectedGroups,
              onSelectGroup: (Group group, bool isSelected) {
                setState(() {
                  if (isSelected) {
                    _selectedGroups.add(group);
                  } else {
                    _selectedGroups.remove(group);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Groups'),
          content: const Text(
              'Are you sure you want to delete the selected groups?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final viewModel =
                    Provider.of<ExpenseViewModel>(context, listen: false);
                for (var group in _selectedGroups) {
                  viewModel.removeGroup(
                      group); // Assuming you have this method in your view model
                }
                _selectedGroups.clear(); // Clear selections after deletion
                Navigator.of(context).pop(); // Close dialog
                setState(() {}); // Refresh the view
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
