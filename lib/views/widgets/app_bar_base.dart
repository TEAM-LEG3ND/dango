import 'package:flutter/material.dart';

class AppBarBase extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBase({
    super.key,
    required this.leading,
    required this.title,
    this.onLeadingTap,
    required this.action,
  });

  final String title;
  final VoidCallback? onLeadingTap;
  final Widget action;
  final Widget leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      leadingWidth: 80,
      leading: Center(
        child: GestureDetector(onTap: onLeadingTap, child: leading),
      ),
      actions: [
        action,
      ],
    );
  }
}
