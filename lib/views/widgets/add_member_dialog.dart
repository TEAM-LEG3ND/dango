import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../viewmodels/expense_viewmodel.dart';

class AddMemberDialog extends StatefulWidget {
  const AddMemberDialog({super.key});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final TextEditingController _memberNameCtrl = TextEditingController();

  @override
  void dispose() {
    _memberNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);

    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: SizedBox(
          width: 400,
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '멤버 추가',
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 32
                      ), // Spacing between input fields
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _memberNameCtrl,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            hintText: '새로운 멤버', // Placeholder text
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
                    height:
                    50, // Ensure the divider takes the full height
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: const VerticalDivider(
                      width: 1, // Divider thickness
                      color: Colors.black, // Divider color
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        String memberName = _memberNameCtrl.text == "" ? "새로운 멤버" : _memberNameCtrl.text;

                        Member? alreadyMember = viewModel.getMemberByName(memberName);
                        if (alreadyMember == null) { // DB에 이름이 겹치지 않게 함.
                          viewModel.addMember(memberName);
                        }
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
