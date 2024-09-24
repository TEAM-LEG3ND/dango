import 'dart:async';
import 'package:dango/services/language_service.dart';
import 'package:dango/utils/app_localization.dart';
import 'package:dango/utils/constants.dart';
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

class _ExpenseItemState extends State<ExpenseItem>
    with SingleTickerProviderStateMixin {
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
      end: const Offset(-0.2, 0.0), // Swipe distance
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _deleteTimer?.cancel(); // Cancel timer if active
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
      _deleteTimer!.cancel(); // Cancel timer
      setState(() {
        _controller.reverse();
        _isDeleteScheduled = false;
      });
    }
  }

  void _changePaidByMember() async {
    final viewModel = Provider.of<ExpenseViewModel>(context, listen: false);
    final currentlySelectedMember = viewModel.selectedMember;

    if (widget.expense.paidBy.first == currentlySelectedMember) {
      return; // Do nothing if it's the same member
    }

    if (currentlySelectedMember != null &&
        currentlySelectedMember != widget.expense.paidBy.first) {
      viewModel.updateExpensePaidBy(
          widget.expense, currentlySelectedMember, widget.expense.paidBy.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);
    final languageService = Provider.of<LanguageService>(context);

    return Padding(
      padding: const EdgeInsets.all(0),
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
            Positioned.fill(
              child: Container(
                color: Colors.red.shade400, // Background color when swiped
              ),
            ),
            SlideTransition(
              position: _offsetAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: viewModel.hasSelectedMemberInShared(widget.expense)
                      ? const Color(0xffC9958C)
                      : const Color(0xffFFFFF1),
                  border: Border.all(
                    color: const Color(0xffDEF2CF),
                    width: 0.3,
                  ),
                ),
                height: 81,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: SizedBox(
                        width: 60,
                        height: 50,
                        child: GestureDetector(
                          onTap: _changePaidByMember,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: widget.expense.paidBy.first ==
                                      viewModel.selectedMember
                                  ? const Color(0xffC9958C)
                                  : const Color(0xff95B47E),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              border: Border.all(
                                color: Colors.white,
                                width: viewModel.hasSelectedMemberInShared(
                                        widget.expense)
                                    ? 2.0
                                    : 0.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Center horizontally
                              children: [
                                // Check if the language is Korean
                                if (languageService.locale.languageCode ==
                                    'ko') ...[
                                  // Show "paid this" text first for Korean
                                  Text(
                                    (AppLocalizations.translate(
                                            'paid_this', context) ??
                                        AppConstants.errorText),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color.fromARGB(255, 0, 122, 170),
                                    ),
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 0),
                                  Text(
                                    widget.expense.paidBy.first.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                ] else ...[
                                  // Default order for other languages
                                  Text(
                                    widget.expense.paidBy.first.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    (AppLocalizations.translate(
                                            'paid_this', context) ??
                                        AppConstants.errorText),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: const Color.fromARGB(
                                          255, 0, 122, 170),
                                    ),
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                ],
                              ],
                            ),
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
                            // Description and Cost on the same line
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.expense.description,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                ),
                                Text(
                                  '\$ ${widget.expense.amount.toString()}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                            const SizedBox(
                                height:
                                    4), // Space below the description and cost
                            // Shared members text
                            if (languageService.locale.languageCode ==
                                'ko') ...[
                              // Korean: "shared this" first
                              Text(
                                '${AppLocalizations.translate('shared_this', context) ?? AppConstants.errorText} ${widget.expense.sharedWith.map((member) => member.name.trim()).join(', ')}',
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ] else ...[
                              // Default order for other languages
                              Text(
                                '${widget.expense.sharedWith.map((member) => member.name.trim()).join(', ')} ${AppLocalizations.translate('shared_this', context) ?? AppConstants.errorText}',
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                            const Spacer(),
                          ],
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
                  right: (_controller.value * 65) - 50,
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
                        child: Text(
                          (AppLocalizations.translate(
                                  'cancel_delete', context) ??
                              AppConstants.errorText),
                          style: const TextStyle(
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
