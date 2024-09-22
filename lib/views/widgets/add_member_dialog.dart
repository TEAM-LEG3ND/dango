import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import '../../models/models.dart';
import '../../viewmodels/expense_viewmodel.dart';

class AddMemberDialog extends StatefulWidget {
  final ObjectId groupId;
  const AddMemberDialog({super.key, required this.groupId});

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
        height: 250,
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
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        style: const TextStyle(fontSize: 32),
                        controller: _memberNameCtrl,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          hintText: '이름', // Placeholder text
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                height: 1.5,
                thickness: 1,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Pop the dialog and cancel the group creation
                      Navigator.of(context)
                          .pop(false); // Pass false to indicate cancellation
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      minimumSize: const Size(double.infinity, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text('닫기'),
                  ),
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: const VerticalDivider(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      String memberName = _memberNameCtrl.text.isEmpty
                          ? "New Member"
                          : _memberNameCtrl.text;

                      Member? alreadyMember = viewModel.getMemberByNameInGroup(
                          widget.groupId, memberName);
                      if (alreadyMember == null) {
                        viewModel.addMember(widget.groupId, memberName);
                        Navigator.of(context).pop(true); // Indicate success
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      minimumSize: const Size(double.infinity, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
