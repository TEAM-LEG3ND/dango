import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class ExpenseViewModel extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<Expense> _expenses = [];

  ExpenseViewModel(this._databaseService);

  List<Expense> get expenses => _expenses;

  Future<void> fetchExpenses() async {
    _expenses = _databaseService.getAllExpenses();
    notifyListeners();
  }

  void showAddMemberPopup(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                width: 400,
                height: 300,
                child: Column(
                  children: [
                    const Text(
                      '멤버 추가하기',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        '닫기',
                      ),
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
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: SizedBox(
                width: 400,
                height: 300,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: DropdownButton<String>(
                          value: 'Option 1',
                          items: <String>['Option 1', 'Option 2', 'Option 3']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Center(child: Text(value)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            // Handle dropdown value change
                          },
                          isExpanded: true, // Ensure dropdown takes full width
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: '내용', // Placeholder text
                                  border: InputBorder.none, // No border
                                  contentPadding: EdgeInsets.all(
                                      16.0), // Padding inside the text field
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: 16), // Spacing between input fields
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  prefixText: '\$ ',
                                  hintText: '0.00', // Placeholder text
                                  border: InputBorder.none, // No border
                                  contentPadding: EdgeInsets.all(
                                      16.0), // Padding inside the text field
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Divider above the buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  Size(double.infinity, 50), // Full width
                              shape: RoundedRectangleBorder(
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
                          child: VerticalDivider(
                            width: 1, // Divider thickness
                            color: Colors.black, // Divider color
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              // Add confirmation action here
                              Navigator.of(context).pop(); // Close dialog
                            },
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 0, 0, 0),
                              minimumSize:
                                  Size(double.infinity, 50), // Full width
                              shape: RoundedRectangleBorder(
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
}
