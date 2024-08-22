import 'package:flutter/material.dart';

class AppBarBase extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBase({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("당고"),
      centerTitle: true,
      leadingWidth: 80,
      leading: Center(
        child: GestureDetector(
          // todo 화면 뒤로 가기
          onTap: () {},
          child: const Row(
            children: [
              SizedBox(width: 8),
              Icon(Icons.arrow_back),
              SizedBox(width: 4),
              Text(
                '뒤로',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      actions: [
        GestureDetector(
          // todo 화면 이동
          onTap: () {},
          child: const Row(
            children: [
              SizedBox(width: 4),
              Text(
                // todo 텍스트 받아서 넣기
                '정산',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ],
    );
  }
}
