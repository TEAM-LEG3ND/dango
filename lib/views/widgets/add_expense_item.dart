import 'package:flutter/cupertino.dart';

class AddExpenseItem extends StatelessWidget {
  const AddExpenseItem({
    super.key,
    required this.addExpense,
  });

  final Function addExpense;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => addExpense(),
      child: Container(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                alignment: Alignment.center,
                color: const Color(0xffFFFFF1),
                height: 80,
                child: const Text(
                  '+ 추가',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
