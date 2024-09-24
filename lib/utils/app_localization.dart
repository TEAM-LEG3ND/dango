import 'package:flutter/material.dart';

class AppLocalizations {
  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('ko', ''),
  ];

  static final Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'add': 'Add',
      'add_member': 'Add member',
      'back': 'Back',
      'cancel': 'Cancel',
      'cancel_delete': 'Cancel Delete',
      'close': 'Close',
      'cost_description': 'Provide a description.',
      'delete': 'Delete',
      'group_delete': 'Delete Group',
      'group_delete_confirmation':
          'Are you sure you want to delete the selected group(s)?',
      'home': 'Home',
      'list': 'List',
      'name': 'Name',
      'name_already_exists': 'This name already exists.',
      'paid_this': "Paid this",
      'save': 'Save',
      'shared_this': 'shared this',
      'settle': 'Settle',
      'settings': 'Settings',
    },
    'ko': {
      'add': '추가',
      'add_member': '멤버 추가',
      'back': '뒤로',
      'cancel': '취소',
      'cancel_delete': '삭제 취소',
      'close': '닫기',
      'cost_description': '비용에 대한 설명을 적으세요.',
      'delete': '삭제',
      'group_delete': '그룹 삭제',
      'group_delete_confirmation': '선택한 그룹을 삭제하시겠습니까?',
      'home': '홈으로',
      'list': '목록',
      'name': '이름',
      'name_already_exists': '이름이 이미 존재합니다.',
      'paid_this': "낸 사람",
      'save': '저장',
      'shared_this': '같이 쓴 사람들:',
      'settle': '정산',
      'settings': '설정',
    },
  };

  static String? translate(String key, BuildContext context) {
    return _localizedStrings[Localizations.localeOf(context).languageCode]![
        key];
  }
}
