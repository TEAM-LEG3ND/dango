import 'package:dango/viewmodels/settlement_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

class SettlementView extends StatefulWidget {
  const SettlementView({super.key, required this.groupId});
  final ObjectId groupId;

  @override
  State<SettlementView> createState() => _SettlementViewState();
}

class _SettlementViewState extends State<SettlementView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettlementViewModel>(
      builder: (context, viewModel, child) {

        return Container(

        );
      },
    );
  }
}
