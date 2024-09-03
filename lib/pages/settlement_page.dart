import 'package:dango/views/widgets/app_bar_base.dart';
import 'package:flutter/material.dart';

class SettlementPage extends StatefulWidget {
  const SettlementPage({super.key});

  @override
  State<SettlementPage> createState() => _SettlementPageState();
}

class _SettlementPageState extends State<SettlementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBase(
        leadingText: '뒤로',
        title: '정산',
        actionText: '완료',
      ),
      body: Container(),
    );
  }
}
