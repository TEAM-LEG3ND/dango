import 'package:dango/views/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dango/viewmodels/expense_viewmodel.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  int itemCount = 5;
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);

    return Column(
      children: <Widget>[
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  itemCount += 1;
                });
              },
              child: const Text('Add Item'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  itemCount -= 1;
                });
              },
              child: const Text('Remove Item'),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(itemCount, (index) {
                return ExpenseItem(
                  description: index.toString(),
                );
              }),
            ),
          ),
        ),
        const Divider(
          color: Colors.black, // 선의 색상
          height: 20, // 위젯의 높이
          thickness: 2, // 선의 두께
          indent: 10, // 왼쪽 여백
          endIndent: 10, // 오른쪽 여백
        ),
        Row(
          children: [
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(itemCount, (index) {
                  return Container(
                      color: Colors.blueAccent,
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Center(
                          child: Text('$index'),
                        ),
                      ));
                }),
              ),
            )),
          ],
        )
      ],
    );
  }
}
