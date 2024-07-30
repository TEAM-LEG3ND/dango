part of 'models.dart';

@RealmModel()
class _Member {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;
  late String name;
  late List<_Expense> paidExpenses;
}