part of 'models.dart';

@RealmModel()
class _Group {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;
  late String name;
  late List<_Member> members;
  late List<_Expense> expenses;
}