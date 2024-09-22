import 'package:dango/views/widgets/add_expense_dialog.dart';
import 'package:dango/views/widgets/add_member_dialog.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class ExpenseViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  final NavigationService _navigationService;

  ExpenseViewModel(this._databaseService, this._navigationService) {
    fetchExpenses();
    fetchMembers();
    fetchGroups();
  }

  Member? _selectedMember;
  Member? get selectedMember => _selectedMember;

  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  List<Member> _members = [];
  List<Member> get members => _members;

  List<Group> _groups = [];
  List<Group> get groups => _groups;

  Future<void> fetchExpenses() async {
    _expenses = _databaseService.getAllExpenses();
    notifyListeners();
  }

  Future<void> fetchMembers() async {
    _members = _databaseService.getAllMembers();
    notifyListeners();
  }

  Future<void> fetchGroups() async {
    _groups = _databaseService.getAllGroups();
    notifyListeners();
  }

  void goBack() {
    _navigationService.goBack();
  }

  void goSettlementPage(groupId) {
    _navigationService.navigateTo('/settlement', arguments: {
      'groupId': groupId,
    });
  }

  void addMember(ObjectId groupId, String name) {
    final newMember = _databaseService.addMember(name);
    _databaseService.addMemberToGroup(groupId, newMember);
    fetchMembers();
  }

  void addExpense(
      ObjectId groupId, String description, double amount, Member paidMember) {
    final newExpense = _databaseService
        .addExpense(description, amount, paidMember, [paidMember]);
    _databaseService.addExpenseToGroup(groupId, newExpense);
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

  void removeGroup(Group group) {
    // Create a copy of the expenses to avoid modifying the list while iterating
    final expensesToRemove = List.from(group.expenses);
    // Remove all expenses associated with the group
    for (var expense in expensesToRemove) {
      _databaseService.removeExpense(expense.id);
    }

    // Create a copy of the members to avoid modifying the list while iterating
    final membersToRemove = List.from(group.members);
    // Remove all members associated with the group
    for (var member in membersToRemove) {
      _databaseService.removeMember(member.id);
    }

    _databaseService.removeGroup(group.id);
    fetchGroups();
  }

  void showAddMemberPopup(BuildContext context, ObjectId groupId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AddMemberDialog(groupId: groupId);
        });
  }

  void showAddExpensePopup(BuildContext context, ObjectId groupId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AddExpenseDialog(groupId: groupId);
        });
  }

  Member? getMemberByNameInGroup(ObjectId groupId, String? name) {
    if (name != null) {
      final group = getGroupById(groupId);
      if (group != null) {
        try {
          return group.members.firstWhere((m) => m.name == name);
        } catch (e) {
          return null;
        }
      }
    }
    return null;
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

  void onToggleExpense(Expense expense) {
    if (hasSelectedMemberInShared(expense)) {
      _databaseService.removeMemberFromExpense(expense.id, _selectedMember);
    } else {
      _databaseService.addMemberToExpense(expense.id, _selectedMember);
    }
    fetchExpenses();
  }

  Future<void> addNewGroup(String groupName) async {
    // Create a new group with mock data
    final newGroup = Group(
      ObjectId(), // Ensure ObjectId is imported correctly
      groupName,
      members: [], // Start with an empty list of members
      expenses: [], // Start with an empty list of expenses
    );

    _databaseService.addGroup(
        newGroup.name, newGroup.members, newGroup.expenses);
    await fetchGroups(); // Refresh the list of groups
    notifyListeners();
  }

  Group? getGroupById(ObjectId id) {
    return _groups.firstWhere((group) => group.id == id);
  }

  void updateGroupName(ObjectId groupId, String newName) async {
    _databaseService.updateGroupName(groupId, newName);
    await fetchGroups();
    notifyListeners();
  }

  String getGroupNameById(ObjectId groupId) {
    return _groups.firstWhere((group) => group.id == groupId).name;
  }

  List<Member> getMembersByGroupId(ObjectId groupId) {
    final group = _groups.firstWhere((g) => g.id == groupId);
    return group.members;
  }
}
