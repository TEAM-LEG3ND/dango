part of 'models.dart';

@RealmModel()
class _List {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;
  late String name;
  late List<_Group> groupList;
}
