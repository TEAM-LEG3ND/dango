import 'package:dango/models/models.dart';
import 'package:dango/pages/expense_page.dart';
import 'package:dango/services/language_service.dart';
import 'package:dango/utils/app_localization.dart';
import 'package:dango/utils/constants.dart';
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
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  _showSettingsDialog(context);
                },
              ),
            ),
            Flexible(
              child: IconButton(
                icon: _isEditing
                    ? const Icon(Icons.view_headline)
                    : const Icon(Icons.edit),
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
            ),
          ],
        ),
        title: Text(AppLocalizations.translate('list', context) ??
            AppConstants.errorText),
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

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.translate('settings', context) ??
              AppConstants.errorText),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('English'),
                  Switch(
                    value: Provider.of<LanguageService>(context)
                            .locale
                            .languageCode ==
                        'ko',
                    onChanged: (value) {
                      Provider.of<LanguageService>(context, listen: false)
                          .toggleLanguage();
                    },
                  ),
                  const Text('한글'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(AppLocalizations.translate('close', context) ??
                  AppConstants.errorText),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0), // Set your desired radius
          ),
          title: Text(AppLocalizations.translate('group_delete', context) ??
              AppConstants.errorText),
          content: Text(AppLocalizations.translate(
                  'group_delete_confirmation', context) ??
              AppConstants.errorText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(AppLocalizations.translate('cancel', context) ??
                  AppConstants.errorText),
            ),
            TextButton(
              onPressed: () {
                final viewModel =
                    Provider.of<ExpenseViewModel>(context, listen: false);
                for (var group in _selectedGroups) {
                  viewModel.removeGroup(group);
                }
                _selectedGroups.clear(); // Clear selections after deletion
                Navigator.of(context).pop(); // Close dialog
                setState(() {}); // Refresh the view
              },
              child: Text(AppLocalizations.translate('delete', context) ??
                  AppConstants.errorText),
            ),
          ],
        );
      },
    );
  }
}
