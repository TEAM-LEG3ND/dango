import 'package:dango/utils/app_localization.dart';
import 'package:dango/utils/constants.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettlementViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBarBase(
            leading: Row(
              children: [
                const SizedBox(width: 8),
                const Icon(Icons.arrow_back),
                const SizedBox(width: 4),
                Text(
                  (AppLocalizations.translate('back', context) ??
                      AppConstants.errorText),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            title: Text(AppLocalizations.translate('settle', context) ??
                AppConstants.errorText),
            action: GestureDetector(
              onTap: () {
                viewModel.goHome();
              },
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  Text(
                    (AppLocalizations.translate('home', context) ??
                        AppConstants.errorText),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.home),
                ],
              ),
            ),
            onLeadingTap: () {
              viewModel.goBack();
            }),
        body: SettlementView(
          groupId: widget.groupId,
        ),
      );
    });
  }
}
