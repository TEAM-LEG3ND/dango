part of 'models.dart';

@RealmModel()
class _Expense {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;
  late String description;
  late double amount;
  @Backlink(#paidExpenses)
  late Iterable<_Member> paidBy;
  late List<_Member> sharedWith;
}