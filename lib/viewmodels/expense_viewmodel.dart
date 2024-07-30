import 'package:flutter/cupertino.dart';
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
}