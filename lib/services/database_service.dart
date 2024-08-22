import 'dart:math';

import 'package:realm/realm.dart';
import '../models/models.dart';

class DatabaseService {
  late Realm realm;

  DatabaseService () {
    final config = Configuration.local(
        [Member.schema, Expense.schema, Group.schema]
    );
    realm = Realm(config);
  }

  // 멤버 추가
  void addMember(String name) {
    final member = Member(ObjectId(), name);
    realm.write((){
      realm.add(member);
    });
  }

  // 비용 추가
  void addExpense(String description, double amount, Member paidBy, List<Member> sharedWith) {
    final expense = Expense(ObjectId(), description, amount, sharedWith: sharedWith);
    realm.write(() {
      realm.add(expense);
      // 백링크로 expense 에는 자동 업데이트
      paidBy.paidExpenses.add(expense);
    });
  }

  // 그룹 추가
  void addGroup(String name, List<Member> members, List<Expense> expenses) {
    final group = Group(ObjectId(), name, members: members, expenses: expenses);
    realm.write(() {
      realm.add(group);
    });
  }

  // 멤버 제거
  void removeMember(ObjectId id) {
    final member = realm.find<Member>(id);
    if (member != null) {
      realm.write(() {
        realm.deleteMany(member.paidExpenses);
        realm.delete(member);
      });
    }
  }

  // 비용 제거
  void removeExpense(ObjectId id) {
    final expense = realm.find<Expense>(id);
    if (expense != null) {
      realm.write(() {
        realm.delete(expense);
      });
    }
  }

  // 그룹 제거
  void removeGroup(ObjectId id) {
    final group = realm.find<Group>(id);
    if (group != null) {
      realm.write(() {
        realm.delete(group);
      });
    }
  }

  // 비용에서 공유 멤버 추가
  void addMemberToExpense(ObjectId expenseId, Member? member) {
    if (member == null) {
      return;
    }

    final expense = realm.find<Expense>(expenseId);
    if (expense != null) {
      realm.write(() {
        expense.sharedWith.add(member);
      });
    }
  }

  // 비용에서 공유 멤버 제거
  void removeMemberFromExpense(ObjectId expenseId, Member? member) {
    if (member == null) {
      return;
    }

    final expense = realm.find<Expense>(expenseId);
    if (expense != null) {
      realm.write(() {
        expense.sharedWith.remove(member);
      });
    }
  }

  bool hasMemberOnExpense(Expense expense, Member? member) {
    if (member == null) {
      return false;
    }
    return expense.sharedWith.contains(member);
  }

  // 그룹에 멤버 추가
  void addMemberToGroup(ObjectId groupId, Member member) {
    final group = realm.find<Group>(groupId);
    if (group != null) {
      realm.write(() {
        group.members.add(member);
      });
    }
  }

  // 그룹에 비용 추가
  void addExpenseToGroup(ObjectId groupId, Expense expense) {
    final group = realm.find<Group>(groupId);
    if (group != null) {
      realm.write(() {
        group.expenses.add(expense);
      });
    }
  }

  // 비용 설명 업데이트
  void updateExpenseDescription(ObjectId expenseId, String newDescription) {
    final expense = realm.find<Expense>(expenseId);
    if (expense != null) {
      realm.write(() {
        expense.description = newDescription;
      });
    }
  }

  // 그룹 이름 업데이트
  void updateGroupName(ObjectId groupId, String newName) {
    final group = realm.find<Group>(groupId);
    if (group != null) {
      realm.write(() {
        group.name = newName;
      });
    }
  }

  // 모든 멤버 가져오기
  List<Member> getAllMembers() {
    return realm.all<Member>().toList();
  }

  // 모든 비용 가져오기
  List<Expense> getAllExpenses() {
    return realm.all<Expense>().toList();
  }

  // 모든 그룹 가져오기
  List<Group> getAllGroups() {
    return realm.all<Group>().toList();
  }

  // 이름으로 멤버 가져오기
  Member? getMemberByName(String name) {
    try {
      return realm.all<Member>().firstWhere((m) => m.name == name);
    } catch (e) {
      return null;
    }
  }

  // 이름으로 비용 가져오기
  Expense? getExpenseByDescription(String description) {
    try {
      return realm.all<Expense>().firstWhere((e) => e.description == description);
    } catch (e) {
      return null;
    }
  }

  // 이름으로 그룹 가져오기
  Group? getGroupByName(String name) {
    try {
      return realm.all<Group>().firstWhere((g) => g.name == name);
    } catch (e) {
      return null;
    }
  }

  void close() {
    realm.close();
  }
}