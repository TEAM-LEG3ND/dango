import 'package:dango/views/widgets/add_expense_item.dart';
import 'package:dango/views/widgets/add_member_item.dart';
import 'package:dango/views/widgets/expense_item.dart';
import 'package:dango/views/widgets/member_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dango/viewmodels/expense_viewmodel.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);

    void showAddMemberPopup () {
      viewModel.showAddMemberPopup(context);
    }

    void showAddExpensePopup () {
      viewModel.showAddExpensePopup(context);
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
                ...viewModel.expenses.map((expense) => ExpenseItem(expense: expense, removeExpense: viewModel.removeExpense,)),
                AddExpenseItem(addExpense: showAddExpensePopup),
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.black, // 선의 색상
          height: 20, // 위젯의 높이
          thickness: 2, // 선의 두께
          indent: 10, // 왼쪽 여백
          endIndent: 10, // 오른쪽 여백
        ),
        Row(
          children: [
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...viewModel.members.map((member) => MemberItem(member: member)),
                  AddMemberItem(addMember: showAddMemberPopup),
                ],
              ),
            )),
          ],
        )
      ],
    );
  }
}
