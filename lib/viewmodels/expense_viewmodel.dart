import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class ExpenseViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<Expense> _expenses = [];

  ExpenseViewModel(this._databaseService);

  List<Expense> get expenses => _expenses;

  Future<void> fetchExpenses() async {
    _expenses = _databaseService.getAllExpenses();
    notifyListeners();
  }

  void showAddMemberPopup(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                width: 400,
                height: 300,
                child: Column(
                  children: [
                    const Text(
                      '멤버 추가하기',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        '닫기',
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  void showAddExpensePopup(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                width: 400,
                height: 300,
                child: Column(
                  children: [
                    const Text(
                      '비용 추가하기',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        '닫기',
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
