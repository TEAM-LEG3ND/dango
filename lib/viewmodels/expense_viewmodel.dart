import 'package:flutter/cupertino.dart';

class ExpenseViewModel extends ChangeNotifier {

  void fetchExpenses() {
    // todo db
    notifyListeners();
  }
}