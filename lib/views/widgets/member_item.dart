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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: 80,
            height: 60,
            child: ElevatedButton(
              onPressed: () => viewModel.selectMember(member),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: viewModel.selectedMember == member ? const Color(0xffC9958C) : const Color(0xff95B47E),
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 10), // 패딩을 넣어 텍스트 공간 확보
              ),
              child: Text(
                member.name.toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
                overflow: TextOverflow.clip,
                maxLines: 1,
              ),
            ),
          ),
          if (viewModel.selectedMember == member)
            Positioned(
              right: -15,
              top: -15,
              child: GestureDetector(
                onTap: () => viewModel.removeMember(member),
                child: ClipOval(
                  child: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                )
              )
            ),
        ],
      ),
    );
  }
}
