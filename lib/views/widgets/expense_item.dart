import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        color: const Color(0xffFFFFF1),
        height: 60,
        child: Center(
          child: Text(
            'Item $description',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
