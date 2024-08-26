import 'package:flutter/material.dart';

class AppBarBase extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBase({
    super.key,
    required this.leadingText,
    required this.title,
    required this.actionText,
    this.onLeadingTap,
  });

  final String title;
  final String leadingText;
  final String actionText;
  final VoidCallback? onLeadingTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      leadingWidth: 80,
      leading: Center(
        child: GestureDetector(
          // todo 화면 뒤로 가기
          onTap: onLeadingTap,
          child: Row(
            children: [
              const SizedBox(width: 8),
              const Icon(Icons.arrow_back),
              const SizedBox(width: 4),
              Text(
                leadingText,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      actions: [
        GestureDetector(
          // todo 화면 이동
          onTap: () {},
          child: Row(
            children: [
              const SizedBox(width: 4),
              Text(
                actionText,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ],
    );
  }
}
