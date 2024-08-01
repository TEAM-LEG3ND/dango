import 'package:flutter/material.dart';

class ExpenseItem extends StatefulWidget {
  const ExpenseItem({
    super.key,
    required this.description,
  });

  final String description;

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
        onTap: () => debugPrint('Expense item tapped'),
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
                    // todo 금액을 낸 멤버 영역
                    SizedBox(
                      width: 60,
                      child: Container(
                        color: Colors.green.shade200,
                      ),
                    ),
                    // todo 금액 설명 부분
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            // 설명
                            Text(
                              '밥값 ${widget.description}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            // 공유 멤버 리스트
                            const SizedBox(
                              height: 20,
                              child: Text(
                                'a, b, c',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // todo 비용 액수
                    SizedBox(
                      width: 80,
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        color: Colors.blue,
                        child: const Text(
                          '100\$',
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
                  // todo 삭제 로직 추가
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