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
    return _groups.firstWhere((group) => group.id == id);
  }


}