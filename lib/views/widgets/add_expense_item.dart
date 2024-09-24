import 'package:dango/utils/app_localization.dart';
import 'package:dango/utils/constants.dart';
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
                child: Text(
                  '+ ${AppLocalizations.translate('add', context) ?? AppConstants.errorText}',
                  style: const TextStyle(
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
