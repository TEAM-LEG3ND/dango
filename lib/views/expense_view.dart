import 'package:dango/models/models.dart';
import 'package:dango/views/widgets/add_expense_item.dart';
import 'package:dango/views/widgets/add_member_item.dart';
import 'package:dango/views/widgets/expense_item.dart';
import 'package:dango/views/widgets/member_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dango/viewmodels/expense_viewmodel.dart';
import 'package:realm/realm.dart';

class ExpenseView extends StatefulWidget {
  final ObjectId groupId;
  final String groupName;

  const ExpenseView({Key? key, required this.groupId, required this.groupName})
      : super(key: key);

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseViewModel>(
      builder: (context, viewModel, child) {
        // Ensure _group is updated from viewModel if necessary
        final group = viewModel.getGroupById(widget.groupId);

        if (group == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Group Detailffs"),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...group.expenses.map((expense) => ExpenseItem(
                          expense: expense,
                          removeExpense: viewModel.removeExpense,
                        )),
                    AddExpenseItem(addExpense: () {
                      viewModel.showAddExpensePopup(context, widget.groupId);
                    }),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
              height: 20,
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...group.members.map((member) => MemberItem(
                              member: member,
                            )),
                        AddMemberItem(addMember: () {
                          viewModel.showAddMemberPopup(context, widget.groupId);
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
