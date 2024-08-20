import 'package:dango/views/widgets/add_expense_dialog.dart';
import 'package:dango/views/widgets/add_member_dialog.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class ExpenseViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  ExpenseViewModel(this._databaseService) {
    fetchExpenses();
    fetchMembers();
  }

  Member? _selectedMember;
  Member? get selectedMember => _selectedMember;

  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  List<Member> _members = [];
  List<Member> get members => _members;

  Future<void> fetchExpenses() async {
    _expenses = _databaseService.getAllExpenses();
    notifyListeners();
  }

  Future<void> fetchMembers() async {
    _members = _databaseService.getAllMembers();
    notifyListeners();
  }

  void addMember(String name) {
    _databaseService.addMember(name);
    fetchMembers();
  }

  void addExpense(String description, double amount, Member paidMember) {
    _databaseService.addExpense(description, amount, paidMember, [paidMember]);
    fetchExpenses();
  }

  void removeExpense(Expense expense) {
    _databaseService.removeExpense(expense.id);
    fetchExpenses();
  }

  void removeMember(Member member) {
    _databaseService.removeMember(member.id);
    _selectedMember = null;
    fetchExpenses();
    fetchMembers();
  }

  void showAddMemberPopup(BuildContext context) {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AddMemberDialog();
        });
  }

  void showAddExpensePopup(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AddExpenseDialog();
        });
  }

  Member? getMemberByName(String? name) {
    if (name != null) {
      String memberName = name;
      return _databaseService.getMemberByName(memberName);
    }
    return null;
  }

  void selectMember(Member member) {
    if (_selectedMember == member) {
      _selectedMember = null;
    } else {
      _selectedMember = member;
    }
    notifyListeners();
  }

  bool hasSelectedMemberInShared(Expense expense) {
      return _databaseService.hasMemberOnExpense(expense, _selectedMember);
  }
}
