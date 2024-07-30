import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: InkWell(
        // todo 비용 아이템 토글
        onTap: () => {debugPrint('Expense item tapped')},
        child: Container(
          color: const Color(0xffFFFFF1),
          height: 70,
          child: Row(
            children: [
              // 금액을 낸 멤버 영역
              SizedBox(
                width: 60,
                // todo 멤버 위젯 넣기
                child: Container(
                  color: Colors.red,
                ),
              ),
              // 금액 설명 부분
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      // 설명
                      Text(
                        '밥값 $description',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      // todo 공유 멤버 리스트
                      const SizedBox(
                        height: 20,
                        child: Text(
                          'a, b, c',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // 비용 액수
              SizedBox(
                width: 70,
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  color: Colors.blue,
                  // todo 비용
                  child: const Text(
                    '100\$'
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
