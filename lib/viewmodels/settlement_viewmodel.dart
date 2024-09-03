import 'package:flutter/cupertino.dart';

import '../services/database_service.dart';

class SettlementViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  SettlementViewModel(this._databaseService);
  
}