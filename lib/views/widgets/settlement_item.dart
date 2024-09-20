import 'package:flutter/cupertino.dart';

class SettlementItem extends StatelessWidget {
  const SettlementItem({
    super.key,
    required this.from,
    required this.to,
    required this.cost,
  });

  final String from;
  final String to;
  final double cost;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(1.5),
        child: Container(
          color: const Color(0xffFFFFF1),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    alignment: Alignment.centerLeft,
                    height: 80,
                    child: Text(
                      '$from  ->  $to',
                      style: const TextStyle(
                        fontSize: 20,
                      )
                    ),
                  ),
              ),
              SizedBox(
                width: 100,
                child: Text(
                    '\$ $cost',
                    style: const TextStyle(
                      fontSize: 18,
                    )
                ),
              )
            ],
          ),
        )
    );
  }
}
