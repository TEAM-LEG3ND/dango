import 'package:dango/viewmodels/expense_viewmodel.dart';
import 'package:dango/views/widgets/app_bar_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  late TextEditingController _groupNameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController(text: widget.groupName);
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveGroupName() {
    final viewModel = Provider.of<ExpenseViewModel>(context, listen: false);
    viewModel.updateGroupName(widget.groupId, _groupNameController.text);
    _toggleEditing();
    setState(() {
      _isEditing = false;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        if (_isEditing) {
          _saveGroupName();
        }
      },
      child: Scaffold(
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
          title: _isEditing
              ? TextField(
                  controller: _groupNameController,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) => _saveGroupName(),
                  onEditingComplete: () => _saveGroupName(),
                )
              : GestureDetector(
                  onTap: _toggleEditing,
                  child: Text(viewModel.getGroupNameById(widget.groupId)),
                ),
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
      ),
    );
  }
}
