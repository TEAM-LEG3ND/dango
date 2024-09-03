import 'package:dango/viewmodels/settlement_viewmodel.dart';
import 'package:dango/views/widgets/settlement_item.dart';
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
        final group = viewModel.getGroupById(widget.groupId);
        if (group == null) {
          return const Text('Error');
        }

        return const Column(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SettlementItem(from: '태균', to: '석우', cost: 100.0),
                  SettlementItem(from: '연경', to: '태균', cost: 100.0),
                  SettlementItem(from: '석우', to: '연경', cost: 100.0),
                ],
              ),
            ),
          ),
        ]);
      },
    );
  }
}
