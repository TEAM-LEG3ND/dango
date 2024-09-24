import 'package:dango/pages/expense_page.dart';
import 'package:dango/pages/group_list_page.dart';
import 'package:dango/pages/settlement_page.dart';
import 'package:dango/services/language_service.dart';
import 'package:dango/viewmodels/expense_viewmodel.dart';
import 'package:dango/viewmodels/settlement_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import './services/database_service.dart';
import './services/navigation_service.dart';
import './utils/app_localization.dart'; // Import your localization class

void main() {
  final navigationService = NavigationService();
  runApp(
    MultiProvider(
      providers: [
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        Provider<NavigationService>(create: (_) => navigationService),
        ChangeNotifierProvider<ExpenseViewModel>(
          create: (context) => ExpenseViewModel(
            Provider.of<DatabaseService>(context, listen: false),
            Provider.of<NavigationService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<SettlementViewModel>(
          create: (context) => SettlementViewModel(
            Provider.of<DatabaseService>(context, listen: false),
            Provider.of<NavigationService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<LanguageService>(
          create: (_) => LanguageService(),
        ),
      ],
      child: Builder(
        builder: (context) {
          // Now you can safely use the context here
          return Consumer<LanguageService>(
            builder: (context, languageProvider, child) {
              return MaterialApp(
                navigatorKey: navigationService.navigatorKey,
                locale: languageProvider.locale, // Set the app locale
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                initialRoute: '/',
                routes: {
                  '/': (context) => const GroupPage(),
                  '/expense': (context) {
                    final args = ModalRoute.of(context)!.settings.arguments
                        as Map<String, dynamic>;
                    final groupId =
                        args['groupId'] ?? 'defaultGroupId' as ObjectId;
                    final groupName = args['groupName'] ?? 'defaultGroupName';
                    return ExpensePage(
                      groupId: groupId,
                      groupName: groupName,
                    );
                  },
                  '/settlement': (context) {
                    final args = ModalRoute.of(context)!.settings.arguments
                        as Map<String, dynamic>;
                    final groupId =
                        args['groupId'] ?? 'defaultGroupId' as ObjectId;
                    return SettlementPage(
                      groupId: groupId,
                    );
                  },
                },
              );
            },
          );
        },
      ),
    ),
  );
}
