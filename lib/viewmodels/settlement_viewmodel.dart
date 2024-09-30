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

  double min(double a, double b) {
    return (a < b) ? a : b;
  }

  void addItemToReceipt(String from, String to, double cost) {
    if (!_receipt.containsKey(from)) {
      // 초기화
      _receipt[from] = {};
    }

    _receipt[from]![to] = (_receipt[from]![to] ?? 0) + cost;
  }

  Future<void> fetchReceipt(Group group) async {
    _receipt = {};
    double remainder = 0;
    final List<Expense> expenses = group.expenses;
    // Create a map from member names to their indices
    Map<String, int> memberIndexMap = {};
    // List to hold member names
    List<String> memberNames = [];
    // Initialize the adjacency list based on the number of members
    // max space (V*V)
    List<List<List<dynamic>>> adjacencyList = List.generate(
        group.members.length,
        (_) =>
            [] // Each member starts with an empty list of outgoing transactions
        );
    List<double> netSum = List.filled(adjacencyList.length, 0);

    // Populate the index map and member names list
    for (int i = 0; i < group.members.length; i++) {
      String memberName = group.members[i].name;
      memberIndexMap[memberName] = i;
      memberNames.add(memberName); // Store member names
    }

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
      // adjacency list (directed weighted graph)
      // 인접리스트 (방향성 가중치 그래프)
      for (var member in expense.sharedWith) {
        String from = member.name;
        if (from != to) {
          adjacencyList[memberIndexMap[from]!]
              .add([memberIndexMap[to]!, costPerMember]);
        }
      }
    }

    //엣지가 2개이하일경우 직접입력
    if (adjacencyList.length < 2) {
      for (int i = 0; i < adjacencyList.length; i++) {
        for (var outgoingEdge in adjacencyList[i]) {
          addItemToReceipt(
              memberNames[i], memberNames[outgoingEdge[0]], outgoingEdge[1]);
        }
      }
      return;
    }

    for (int i = 0; i < adjacencyList.length; i++) {
      for (var outgoingEdge in adjacencyList[i]) {
        netSum[i] -= outgoingEdge[1];
        netSum[outgoingEdge[0]] += outgoingEdge[1];
      }
    }

    while (true) {
      int minValueIdx = 0, maxValueIdx = 0;

      for (int i = 0; i < netSum.length; i++) {
        if (netSum[i] < netSum[minValueIdx]) {
          minValueIdx = i;
        }
        if (netSum[i] > netSum[maxValueIdx]) {
          maxValueIdx = i;
        }
      }

      if (netSum[minValueIdx] == 0) {
        break;
      }

      double cost = min(-netSum[minValueIdx], netSum[maxValueIdx]);

      netSum[minValueIdx] += cost;
      netSum[maxValueIdx] -= cost;

      String from = memberNames[minValueIdx];
      String to = memberNames[maxValueIdx];

      addItemToReceipt(from, to, cost);
    }

    return;
  }
}
