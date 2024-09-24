import 'package:dango/utils/app_localization.dart';
import 'package:dango/utils/constants.dart';
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
  String? _errorMessage;

  @override
  void dispose() {
    _memberNameCtrl.dispose();
    super.dispose();
  }

  void _onMemberNameChanged() {
    // Clear the error message when the user starts typing
    setState(() {
      _errorMessage = null;
    });
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        (AppLocalizations.translate('add_member', context) ??
                            AppConstants.errorText),
                        style: const TextStyle(
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
                        decoration: InputDecoration(
                          hintText:
                              (AppLocalizations.translate('name', context) ??
                                  AppConstants.errorText),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(0.0),
                        ),
                        onChanged: (text) => _onMemberNameChanged(),
                      ),
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
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
                      Navigator.of(context).pop(false);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      minimumSize: const Size(double.infinity, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(AppLocalizations.translate('close', context) ??
                        AppConstants.errorText),
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

                      // Check if the member name is longer than 5 characters
                      if (memberName.length > 5) {
                        setState(() {
                          _errorMessage = (AppLocalizations.translate(
                                  'name_too_long', context) ??
                              AppConstants.errorText);
                        });
                        return;
                      }

                      Member? alreadyMember = viewModel.getMemberByNameInGroup(
                          widget.groupId, memberName);
                      if (alreadyMember != null) {
                        setState(() {
                          _errorMessage = (AppLocalizations.translate(
                                  'name_already_exists', context) ??
                              AppConstants.errorText);
                        });
                      } else {
                        viewModel.addMember(widget.groupId, memberName);
                        Navigator.of(context).pop(true);
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      minimumSize: const Size(double.infinity, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(AppLocalizations.translate('save', context) ??
                        AppConstants.errorText),
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
