// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Member extends _Member with RealmEntity, RealmObjectBase, RealmObject {
  Member(
    ObjectId id,
    String name, {
    Iterable<Expense> paidExpenses = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set<RealmList<Expense>>(
        this, 'paidExpenses', RealmList<Expense>(paidExpenses));
  }

  Member._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmList<Expense> get paidExpenses =>
      RealmObjectBase.get<Expense>(this, 'paidExpenses') as RealmList<Expense>;
  @override
  set paidExpenses(covariant RealmList<Expense> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Member>> get changes =>
      RealmObjectBase.getChanges<Member>(this);

  @override
  Stream<RealmObjectChanges<Member>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Member>(this, keyPaths);

  @override
  Member freeze() => RealmObjectBase.freezeObject<Member>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'name': name.toEJson(),
      'paidExpenses': paidExpenses.toEJson(),
    };
  }

  static EJsonValue _toEJson(Member value) => value.toEJson();
  static Member _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'name': EJsonValue name,
        'paidExpenses': EJsonValue paidExpenses,
      } =>
        Member(
          fromEJson(id),
          fromEJson(name),
          paidExpenses: fromEJson(paidExpenses),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Member._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Member, 'Member', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('paidExpenses', RealmPropertyType.object,
          linkTarget: 'Expense', collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Expense extends _Expense with RealmEntity, RealmObjectBase, RealmObject {
  Expense(
    ObjectId id,
    String description,
    double amount, {
    Iterable<Member> sharedWith = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set<RealmList<Member>>(
        this, 'sharedWith', RealmList<Member>(sharedWith));
  }

  Expense._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  double get amount => RealmObjectBase.get<double>(this, 'amount') as double;
  @override
  set amount(double value) => RealmObjectBase.set(this, 'amount', value);

  @override
  RealmList<Member> get sharedWith =>
      RealmObjectBase.get<Member>(this, 'sharedWith') as RealmList<Member>;
  @override
  set sharedWith(covariant RealmList<Member> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmResults<Member> get paidBy {
    if (!isManaged) {
      throw RealmError('Using backlinks is only possible for managed objects.');
    }
    return RealmObjectBase.get<Member>(this, 'paidBy') as RealmResults<Member>;
  }

  @override
  set paidBy(covariant RealmResults<Member> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Expense>> get changes =>
      RealmObjectBase.getChanges<Expense>(this);

  @override
  Stream<RealmObjectChanges<Expense>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Expense>(this, keyPaths);

  @override
  Expense freeze() => RealmObjectBase.freezeObject<Expense>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'description': description.toEJson(),
      'amount': amount.toEJson(),
      'sharedWith': sharedWith.toEJson(),
    };
  }

  static EJsonValue _toEJson(Expense value) => value.toEJson();
  static Expense _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'description': EJsonValue description,
        'amount': EJsonValue amount,
        'sharedWith': EJsonValue sharedWith,
      } =>
        Expense(
          fromEJson(id),
          fromEJson(description),
          fromEJson(amount),
          sharedWith: fromEJson(sharedWith),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Expense._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Expense, 'Expense', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('amount', RealmPropertyType.double),
      SchemaProperty('sharedWith', RealmPropertyType.object,
          linkTarget: 'Member', collectionType: RealmCollectionType.list),
      SchemaProperty('paidBy', RealmPropertyType.linkingObjects,
          linkOriginProperty: 'paidExpenses',
          collectionType: RealmCollectionType.list,
          linkTarget: 'Member'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Group extends _Group with RealmEntity, RealmObjectBase, RealmObject {
  Group(
    ObjectId id,
    String name, {
    Iterable<Member> members = const [],
    Iterable<Expense> expenses = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set<RealmList<Member>>(
        this, 'members', RealmList<Member>(members));
    RealmObjectBase.set<RealmList<Expense>>(
        this, 'expenses', RealmList<Expense>(expenses));
  }

  Group._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmList<Member> get members =>
      RealmObjectBase.get<Member>(this, 'members') as RealmList<Member>;
  @override
  set members(covariant RealmList<Member> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<Expense> get expenses =>
      RealmObjectBase.get<Expense>(this, 'expenses') as RealmList<Expense>;
  @override
  set expenses(covariant RealmList<Expense> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Group>> get changes =>
      RealmObjectBase.getChanges<Group>(this);

  @override
  Stream<RealmObjectChanges<Group>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Group>(this, keyPaths);

  @override
  Group freeze() => RealmObjectBase.freezeObject<Group>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'name': name.toEJson(),
      'members': members.toEJson(),
      'expenses': expenses.toEJson(),
    };
  }

  static EJsonValue _toEJson(Group value) => value.toEJson();
  static Group _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'name': EJsonValue name,
        'members': EJsonValue members,
        'expenses': EJsonValue expenses,
      } =>
        Group(
          fromEJson(id),
          fromEJson(name),
          members: fromEJson(members),
          expenses: fromEJson(expenses),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Group._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Group, 'Group', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('members', RealmPropertyType.object,
          linkTarget: 'Member', collectionType: RealmCollectionType.list),
      SchemaProperty('expenses', RealmPropertyType.object,
          linkTarget: 'Expense', collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
