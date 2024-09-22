import 'package:dango/viewmodels/settlement_viewmodel.dart';
import 'package:dango/views/widgets/settlement_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import '../models/models.dart';

class SettlementView extends StatefulWidget {
  const SettlementView({super.key, required this.groupId});
  final ObjectId groupId;

  Future<List<SettlementItem>> getSettlementItems(
      SettlementViewModel viewModel) async {
    Group? group = viewModel.getGroupById(groupId);
    if (group != null) {
      await viewModel.fetchReceipt(group);
    }
    List<SettlementItem> items = [];

    viewModel.receipt.forEach((from, innerMap) {
      innerMap.forEach((to, cost) {
        items.add(SettlementItem(from: from, to: to, cost: cost));
      });
    });

    return items;
  }

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

        return FutureBuilder<List<SettlementItem>>(
          future: widget.getSettlementItems(viewModel),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<SettlementItem> settlementItems = snapshot.data!;
              return Column(children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: settlementItems),
                  ),
                ),
              ]);
            } else {
              return const Column(children: <Widget>[
                SizedBox(
                  height: 10,
                ),
              ]);
            }
          },
        );
      },
    );
  }
}
