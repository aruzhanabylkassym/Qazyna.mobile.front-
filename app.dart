import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/cookie_store.dart';
import 'core/http_client.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/registration_email_screen.dart';
import 'screens/auth/code_verification_screen.dart';
import 'screens/auth/password_creation_screen.dart';
import 'screens/consumer/consumer_main_screen.dart';
import 'screens/supplier/supplier_main_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'services/auth_service.dart';

class AppState extends ChangeNotifier {
  final CookieStore cookies = CookieStore();
  late final HttpClient http = HttpClient(cookies);
  late final AuthService auth = AuthService(http, cookies);

  String? sid;
  String? userLogin; // Store the actual user login after authentication

  Future<void> refreshSid() async {
    sid = await cookies.loadSid();
    notifyListeners();
  }

  void setUserLogin(String login) {
    userLogin = login;
    notifyListeners();
  }
}

class QazynaApp extends StatelessWidget {
  const QazynaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()..refreshSid()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: "Qazyna",
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF768C4A),
        ),
        initialRoute: "/",
        routes: {
          "/": (_) => const OnboardingScreen(),
          "/login": (_) => const LoginScreen(),
          "/register": (_) => const RegistrationEmailScreen(),
          "/verify": (_) => const CodeVerificationScreen(),
          "/create-password": (_) => const PasswordCreationScreen(),
          "/consumer/home": (_) => const ConsumerMainScreen(),
          "/supplier/home": (_) => const SupplierMainScreen(),
        },
      ),
    );
  }
}
