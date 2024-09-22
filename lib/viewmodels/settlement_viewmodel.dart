import 'package:flutter/cupertino.dart';
import 'package:realm/realm.dart';

import '../models/models.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class SettlementViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  final NavigationService _navigationService;
  SettlementViewModel(this._databaseService, this._navigationService) {
    fetchGroups();
  }

  // from 이 to 에게 보내야 하는 돈
  // [$from][$to] = cost
  Map<String, Map<String, double>> _receipt = {};
  Map<String, Map<String, double>> get receipt => _receipt;

  List<Group> _groups = [];
  List<Group> get groups => _groups;

  List<Member> _groupMembers = [];
  List<Member> get groupMembers => _groupMembers;

  Future<void> fetchGroups() async {
    _groups = _databaseService.getAllGroups();
    notifyListeners();
  }

  Future<void> fetchGroupMembers(Group group) async {
    _groupMembers = group.members;
    notifyListeners();
  }

  void goBack() {
    _navigationService.goBack();
  }

  void goHome() {
    _navigationService.navigateToAndRemoveUntil('/');
  }

  Group? getGroupById(ObjectId id) {
    try {
      fetchGroups(); // Ensure groups are fetched !!!
      return _groups.firstWhere((group) => group.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchReceipt(Group group) async {
    // 초기화
    _receipt = {};
    double remainder = 0;
    final List<Expense> expenses = group.expenses;

    for (var expense in expenses) {
      // 비용을 받을 사람
      String to = expense.paidBy.first.name;
      double cost = expense.amount;

      double costPerMember =
          (cost / expense.sharedWith.length * 100).floor() / 100;
      // 엔빵하고 나머지 비용 적립
      // todo 처리 고민 지금은 낸 사람이 냄
      remainder += (cost -
          double.parse(
              (costPerMember * expense.sharedWith.length).toStringAsFixed(2)));

      for (var member in expense.sharedWith) {
        String from = member.name;
        if (from != to) {
          addItemToReceipt(from, to, costPerMember);
        }
      }
    }
  }

  void addItemToReceipt(String from, String to, double cost) {
    if (!_receipt.containsKey(from)) {
      // 초기화
      _receipt[from] = {};
    }

    _receipt[from]![to] = (_receipt[from]![to] ?? 0) + cost;
  }
}
