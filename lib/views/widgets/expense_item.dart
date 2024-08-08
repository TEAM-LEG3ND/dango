import 'package:flutter/material.dart';

import '../../models/models.dart';

class ExpenseItem extends StatefulWidget {
  const ExpenseItem({
    super.key,
    required this.expense,
    required this.removeExpense,
  });

  final Expense expense;
  final Function removeExpense;

  @override
  State<ExpenseItem> createState() => _ExpenseItemState();
}

class _ExpenseItemState extends State<ExpenseItem> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _isSwiped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.2, 0.0), // 스와이프 이동 거리
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSwipe(bool forward) {
    setState(() {
      _isSwiped = forward;
      if (forward) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! < 0) {
            _handleSwipe(true);
          } else {
            _handleSwipe(false);
          }
        },
        onTap: () => debugPrint('Expense item tapped : ${widget.expense.description}'),
        child: Stack(
          children: [
            // 배경색을 표시하는 레이어
            Positioned.fill(
              child: Container(
                color: Colors.red.shade400, // 스와이프 되는 부분의 배경색
              ),
            ),
            SlideTransition(
              position: _offsetAnimation,
              child: Container(
                color: const Color(0xffFFFFF1),
                height: 80,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: SizedBox(
                        width: 60,
                        height: 50,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.green.shade200,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.expense.paidBy.first.name,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            // 설명
                            Text(
                              widget.expense.description,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            // 공유 멤버 리스트
                            SizedBox(
                              height: 20,
                              child: Text(
                                widget.expense.sharedWith.map((member) => member.name).join(', '),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        //color: Colors.blue,
                        child: Text(
                          '\$ ${widget.expense.amount.toString()}',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              right: _isSwiped ? 14 : -65,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 32,
                  color: Colors.white,
                ),
                onPressed: () {
                  // todo 삭제 취소
                  widget.removeExpense(widget.expense);
                  debugPrint('Delete button pressed');
                },
                splashColor: Colors.transparent, // 클릭 시 물결 효과 투명
                highlightColor: Colors.transparent, // 클릭 시 강조 효과 투명
              ),
            ),
          ],
        ),
      ),
    );
  }
}