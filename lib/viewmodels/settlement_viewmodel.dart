import 'package:flutter/cupertino.dart';

import '../services/database_service.dart';
import '../services/navigation_service.dart';

class SettlementViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  final NavigationService _navigationService;
  SettlementViewModel(this._databaseService, this._navigationService);


  void goBack() {
    _navigationService.goBack();
  }
}