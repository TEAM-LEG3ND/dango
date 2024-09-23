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
  }

  Future<void> fetchGroupMembers(Group group) async {
    _groupMembers = group.members;
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

      // 각 비용값 처리
      for (var member in expense.sharedWith) {
        String from = member.name;
        if (from != to) {
          addItemToReceipt(from, to, costPerMember);
        }
      }
    }

    // 영수증 최적화 a->b, b->a 처리
    optimizeReceipt();
  }

  void addItemToReceipt(String from, String to, double cost) {
    if (!_receipt.containsKey(from)) {
      // 초기화
      _receipt[from] = {};
    }

    _receipt[from]![to] = (_receipt[from]![to] ?? 0) + cost;
  }

  void optimizeReceipt() {
    final entries = _receipt.entries.toList();

    for (var entry in entries) {
      String from = entry.key;
      Map<String, double> toMap = entry.value;

      for (var toEntry in toMap.entries) {
        String to = toEntry.key;
        double amount = toEntry.value;

        // 반대 방향의 거래가 있는지 확인
        if (_receipt.containsKey(to) && _receipt[to]!.containsKey(from)) {
          double reverseAmount = _receipt[to]![from]!;

          if (amount > reverseAmount) {
            // from -> to 금액에서 to -> from 금액을 뺍니다.
            _receipt[from]![to] = amount - reverseAmount;
            // to -> from은 제거합니다.
            _receipt[to]!.remove(from);
            if (_receipt[to]!.isEmpty) {
              _receipt.remove(to);
            }
          } else if (amount < reverseAmount) {
            // to -> from 금액에서 from -> to 금액을 뺍니다.
            _receipt[to]![from] = reverseAmount - amount;
            // from -> to는 제거합니다.
            _receipt[from]!.remove(to);
            if (_receipt[from]!.isEmpty) {
              _receipt.remove(from);
            }
          } else {
            // 금액이 같다면 둘 다 제거합니다.
            _receipt[from]!.remove(to);
            _receipt[to]!.remove(from);
            if (_receipt[from]!.isEmpty) {
              _receipt.remove(from);
            }
            if (_receipt[to]!.isEmpty) {
              _receipt.remove(to);
            }
          }
        }
      }
    }
  }
}
