import 'package:flutter/material.dart';

class AddMemberItem extends StatelessWidget {
  const AddMemberItem({
    super.key,
    required this.addMember,
  });

  final Function addMember;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: 80,
        height: 60,
        child: ElevatedButton(
          // todo 선택 시 멤버 추가
          onPressed: () => addMember(),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: const Color(0xff95B47E),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 24,
              ),
              softWrap: false,
            ),
          ),
        ),
      ),
    );
  }
}
