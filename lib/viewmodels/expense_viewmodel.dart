import 'package:dango/views/widgets/add_expense_dialog.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class ExpenseViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  ExpenseViewModel(this._databaseService) {
    fetchExpenses();
    fetchMembers();
  }

  // todo 컨트롤러는 뷰 쪽으로 이동 + 멤버 팝업도 옮겨야 함.
  final TextEditingController _memberNameCtrl = TextEditingController();

  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  List<Member> _members = [];
  List<Member> get members => _members;

  Future<void> fetchExpenses() async {
    _expenses = _databaseService.getAllExpenses();
    notifyListeners();
  }

  Future<void> fetchMembers() async {
    _members = _databaseService.getAllMembers();
    notifyListeners();
  }

  void addMember(String name) {
    _databaseService.addMember(name);
    fetchMembers();
  }

  void addExpense(String description, double amount, Member paidMember) {
    _databaseService.addExpense(description, amount, paidMember, [paidMember]);
    fetchExpenses();
  }

  void removeExpense(Expense expense) {
    _databaseService.removeExpense(expense.id);
    fetchExpenses();
  }

  void showAddMemberPopup(BuildContext context) {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: SizedBox(
                width: 400,
                height: 300,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '멤버 추가',
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: 32
                            ), // Spacing between input fields
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                controller: _memberNameCtrl,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: const InputDecoration(
                                  hintText: '새로운 멤버', // Placeholder text
                                  border: InputBorder.none, // No border
                                  contentPadding: EdgeInsets.all(16.0), // Padding inside the text field
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Divider above the buttons
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(
                        height: 1.5,
                        thickness: 1,
                        color: Color.fromARGB(255, 0, 0, 0), // Divider color
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            style: TextButton.styleFrom(
                              foregroundColor:
                              const Color.fromARGB(255, 0, 0, 0),
                              minimumSize:
                              const Size(double.infinity, 50), // Full width
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.zero, // No rounded corners
                              ),
                            ),
                            child: const Text('닫기'),
                          ),
                        ),
                        Container(
                          height:
                          50, // Ensure the divider takes the full height
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: const VerticalDivider(
                            width: 1, // Divider thickness
                            color: Colors.black, // Divider color
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Member? alreadyMember = _databaseService.getMemberByName(_memberNameCtrl.text);
                              if (alreadyMember == null) { // DB에 이름이 겹치지 않게 함.
                                _databaseService.addMember(_memberNameCtrl.text);
                                fetchMembers();
                              }
                              Navigator.of(context).pop(); // Close dialog
                            },
                            style: TextButton.styleFrom(
                              foregroundColor:
                              const Color.fromARGB(255, 0, 0, 0),
                              minimumSize:
                              const Size(double.infinity, 50), // Full width
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.zero, // No rounded corners
                              ),
                            ),
                            child: const Text('저장'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  void showAddExpensePopup(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AddExpenseDialog();
        });
  }

  Member? getPaidMemberByName(String? name) {
    if (name != null) {
      String paidMemberName = name;
      return _databaseService.getMemberByName(paidMemberName);
    }
    return null;
  }

  @override
  void dispose() {
    _memberNameCtrl.dispose();
    super.dispose();
  }
}
