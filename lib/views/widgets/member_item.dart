import 'package:flutter/material.dart';

class MemberItem extends StatelessWidget {
  const MemberItem({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: 80,
        height: 60,
        child: ElevatedButton(
          // todo 선택 시 토글
          onPressed: () => {},
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: const Color(0xff95B47E),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: Text(
            name,
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
