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
    print(_receipt);
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
    // 첫 번째 단계: 값을 0으로 만들고 제거하지 않음
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
            _receipt[to]![from] = 0; // to -> from은 0으로 설정
          } else if (amount < reverseAmount) {
            // to -> from 금액에서 from -> to 금액을 뺍니다.
            _receipt[to]![from] = reverseAmount - amount;
            _receipt[from]![to] = 0; // from -> to는 0으로 설정
          } else {
            // 금액이 같다면 둘 다 0으로 설정합니다.
            _receipt[from]![to] = 0;
            _receipt[to]![from] = 0;
          }
        }
      }
    }

    // 두 번째 단계: 값이 0인 항목들을 제거
    _removeZeroEntries();
  }

  void _removeZeroEntries() {
    // _receipt의 각 항목을 순회하면서 값이 0인 항목들을 제거
    final entries = _receipt.entries.toList();

    for (var entry in entries) {
      String from = entry.key;
      Map<String, double> toMap = entry.value;

      toMap.removeWhere((to, amount) => amount == 0);

      // toMap이 비었으면 해당 항목도 제거
      if (toMap.isEmpty) {
        _receipt.remove(from);
      }
    }
  }
}
