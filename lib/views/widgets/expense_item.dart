import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../viewmodels/expense_viewmodel.dart';

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
  bool _isDeleteScheduled = false;
  Timer? _deleteTimer;

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
    _deleteTimer?.cancel(); // 타이머가 실행 중이라면 취소
    super.dispose();
  }

  void _handleSwipe(bool forward) {
    setState(() {
      if (forward) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _scheduleDelete() {
    setState(() {
      _isDeleteScheduled = true;
      _deleteTimer = Timer(const Duration(seconds: 3), () {
        widget.removeExpense(widget.expense);
        setState(() {
          _controller.reverse();
          _isDeleteScheduled = false;
        });
      });
    });
  }

  void _cancelDelete() {
    if (_deleteTimer != null && _deleteTimer!.isActive) {
      _deleteTimer!.cancel(); // 타이머 취소
      setState(() {
        _controller.reverse();
        _isDeleteScheduled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);

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
        onTap: () => viewModel.onToggleExpense(widget.expense),
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
                color: viewModel.hasSelectedMemberInShared(widget.expense)
                    ? const Color(0xffC9958C)
                    : const Color(0xffFFFFF1),
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
                            color: widget.expense.paidBy.first == viewModel.selectedMember
                                ? const Color(0xffC9958C)
                                : const Color(0xff95B47E),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: viewModel.hasSelectedMemberInShared(widget.expense)
                                  ? 2.0
                                  : 0.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.expense.paidBy.first.name,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            // 설명
                            Text(
                              widget.expense.description,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),
                            const Spacer(),
                            // 공유 멤버 리스트
                            Text(
                              widget.expense.sharedWith.map((member) => member.name.trim()).join(', '),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
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
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  right: (_controller.value * 65) - 50, // 아이콘이 리스트와 함께 이동하도록 동기화
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 32,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _scheduleDelete();
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                );
              },
            ),
            if (_isDeleteScheduled)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: const Color(0xff95B47E),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: _cancelDelete,
                        child: const Text(
                          '삭제 취소 ↵',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}