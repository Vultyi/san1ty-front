import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/screens/commerce_intro_screen.dart';
import 'package:estrutura_front_san1ty/screens/commerce_list_screen.dart';
import 'package:estrutura_front_san1ty/screens/commerce_onboarding_screen.dart';
import 'package:estrutura_front_san1ty/screens/commerce_plan_screen.dart';
import 'package:estrutura_front_san1ty/screens/commerce_dashboard_screen.dart';
import 'package:estrutura_front_san1ty/screens/sales_screen.dart';
import 'package:estrutura_front_san1ty/screens/statement_screen.dart';
import 'package:estrutura_front_san1ty/screens/wallet_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_home_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_manage_keys_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_pay_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_value_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_success_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_register_key_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_confirm_email_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_confirm_phone_screen.dart';
import 'package:estrutura_front_san1ty/screens/login_screen.dart';
import 'package:estrutura_front_san1ty/screens/splash_screen.dart';
import 'package:estrutura_front_san1ty/screens/support_login_screen.dart';
import 'package:estrutura_front_san1ty/screens/support_dashboard_screen.dart';
import 'package:estrutura_front_san1ty/screens/support_chats_screen.dart';
import 'package:estrutura_front_san1ty/screens/support_approval_screen.dart';
import 'package:estrutura_front_san1ty/screens/support_history_screen.dart';
import 'package:estrutura_front_san1ty/screens/admin_login_screen.dart';
import 'package:estrutura_front_san1ty/screens/admin_dashboard_screen.dart';
import 'package:estrutura_front_san1ty/screens/admin_team_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final Map<String, WidgetBuilder> routes = {
    CommerceIntroScreen.routeName: (_) => const CommerceIntroScreen(),
    CommercePlanScreen.routeName: (_) => const CommercePlanScreen(),
    CommerceOnboardingScreen.routeName: (_) => const CommerceOnboardingScreen(),
    CommerceListScreen.routeName: (_) => const CommerceListScreen(),
    CommerceDashboardScreen.routeName: (_) => const CommerceDashboardScreen(),
    SalesScreen.routeName: (_) => const SalesScreen(),
    StatementScreen.routeName: (_) => const StatementScreen(),
    WalletScreen.routeName: (_) => const WalletScreen(),
    PixHomeScreen.routeName: (_) => const PixHomeScreen(),
    PixManageKeysScreen.routeName: (_) => const PixManageKeysScreen(),
    PixPayScreen.routeName: (_) => const PixPayScreen(),
    PixValueScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final recipientKey = args?['recipientKey'] as String? ?? '';
      return PixValueScreen(recipientKey: recipientKey);
    },
    PixSuccessScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final amount = args?['amount'] as String? ?? '0';
      final recipientKey = args?['recipientKey'] as String? ?? '';
      final timestamp = args?['timestamp'] as DateTime? ?? DateTime.now();
      return PixSuccessScreen(amount: amount, recipientKey: recipientKey, timestamp: timestamp);
    },
    PixRegisterKeyScreen.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final keyType = args?['keyType'] as String? ?? 'cpf';
      return PixRegisterKeyScreen(keyType: keyType);
    },
    PixConfirmEmailScreen.routeName: (_) => const PixConfirmEmailScreen(),
    PixConfirmPhoneScreen.routeName: (_) => const PixConfirmPhoneScreen(),
    SplashScreen.routeName: (_) => const SplashScreen(),
    LoginScreen.routeName: (_) => const LoginScreen(),
    // Support Routes
    SupportLoginScreen.routeName: (_) => const SupportLoginScreen(),
    SupportDashboardScreen.routeName: (_) => const SupportDashboardScreen(),
    SupportChatsScreen.routeName: (_) => const SupportChatsScreen(),
    SupportApprovalScreen.routeName: (_) => const SupportApprovalScreen(),
    SupportHistoryScreen.routeName: (_) => const SupportHistoryScreen(),
    // Admin Routes
    '/admin/login': (_) => const AdminLoginScreen(),
    '/admin/dashboard': (_) => const AdminDashboardScreen(),
    '/admin/team': (_) => const AdminTeamScreen(),
    '/admin/chats': (_) => const Placeholder(), // TODO: Implement admin chats screen
    '/admin/settings': (_) => const Placeholder(), // TODO: Implement admin settings screen
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'San1ty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
        canvasColor: const Color(0xFF000000),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000),
          elevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF000000),
          selectedItemColor: Color(0xFF007AFF),
          unselectedItemColor: Color(0xFF8E8E93),
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
      routes: routes,
    );
  }
}
