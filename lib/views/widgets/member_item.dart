import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../viewmodels/expense_viewmodel.dart';

class MemberItem extends StatelessWidget {
  const MemberItem({
    super.key,
    required this.member,
  });

  final Member member;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: 80,
        height: 60,
        child: ElevatedButton(
          onPressed: () => viewModel.selectMember(member),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: const Color(0xff95B47E),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: Text(
            member.name.toString(),
            style: const TextStyle(
              fontSize: 22,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
