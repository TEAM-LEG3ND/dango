import 'package:dango/viewmodels/settlement_viewmodel.dart';
import 'package:dango/views/settlement_view.dart';
import 'package:dango/views/widgets/app_bar_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

class SettlementPage extends StatefulWidget {
  const SettlementPage({super.key, required this.groupId});
  final ObjectId groupId;

  @override
  State<SettlementPage> createState() => _SettlementPageState();
}

class _SettlementPageState extends State<SettlementPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettlementViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBarBase(
                leading: const Row(
                  children: [
                    SizedBox(width: 8),
                    Icon(Icons.arrow_back),
                    SizedBox(width: 4),
                    Text(
                      '뒤로',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                title: '정산',
                action: const Row(
                  children: [
                    SizedBox(width: 4),
                    Text(
                      // todo
                      '홈으로',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
                onLeadingTap: () {
                  viewModel.goBack();
                }
            ),
            body: SettlementView(
              groupId: widget.groupId,
            ),
          );
        }
    );
  }
}
