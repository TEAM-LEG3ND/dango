import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../viewmodels/expense_viewmodel.dart';

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  String? selectedMember;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);

    if (selectedMember == null && viewModel.members.isNotEmpty) {
      selectedMember = viewModel.members.first.name;
    }

    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: SizedBox(
          width: 400,
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: DropdownButton<String>(
                      value: selectedMember,
                      items: viewModel.members
                          .map<DropdownMenuItem<String>>((Member member) {
                        return DropdownMenuItem<String>(
                          value: member.name,
                          child: Center(child: Text(member.name)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        // Handle dropdown value change
                        setState(() {
                          selectedMember = newValue;
                        });
                      },
                      isExpanded: true, // Ensure dropdown takes full width
                      hint: const Text(
                        '멤버를 추가하세요.',
                      )
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: '우리가 쓴 돈', // Placeholder text
                            border: InputBorder.none, // No border
                            contentPadding: EdgeInsets.all(16.0), // Padding inside the text field
                          ),
                        ),
                      ),
                      SizedBox(
                          height: 16
                      ), // Spacing between input fields
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            prefixText: '\$ ',
                            hintText: '\$0.00', // Placeholder text
                            border: InputBorder.none, // No border
                            contentPadding: EdgeInsets.all(16.0), // Padding inside the text field
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Divider above the buttons
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  height: 1.5,
                  thickness: 1,
                  color: Color.fromARGB(255, 0, 0, 0), // Divider color
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                        const Color.fromARGB(255, 0, 0, 0),
                        minimumSize:
                        const Size(double.infinity, 50), // Full width
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.zero, // No rounded corners
                        ),
                      ),
                      child: const Text('닫기'),
                    ),
                  ),
                  Container(
                    height: 50, // Ensure the divider takes the full height
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: const VerticalDivider(
                      width: 1, // Divider thickness
                      color: Colors.black, // Divider color
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // todo Add confirmation action here
                        Navigator.of(context).pop(); // Close dialog
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                        const Color.fromARGB(255, 0, 0, 0),
                        minimumSize:
                        const Size(double.infinity, 50), // Full width
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.zero, // No rounded corners
                        ),
                      ),
                      child: const Text('저장'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
