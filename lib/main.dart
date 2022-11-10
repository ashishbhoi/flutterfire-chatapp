import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/shared/shared_preferences_state.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    // If you wish to record a "non-fatal" exception, please use `FirebaseCrashlytics.instance.recordFlutterError` instead
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // If you wish to record a "non-fatal" exception, please remove the "fatal" parameter
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    getLoggedInStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme? lightColorScheme;
    ColorScheme? darkColorScheme;
    return DynamicColorBuilder(builder:
        (ColorScheme? lightDynamicColor, ColorScheme? darkDynamicScheme) {
      if (lightDynamicColor != null || darkDynamicScheme != null) {
        lightColorScheme = lightDynamicColor;
        darkColorScheme = darkDynamicScheme;
      } else {
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: const Color(0xFF7A5900),
          brightness: Brightness.light,
        );
        darkColorScheme = ColorScheme.fromSeed(
          seedColor: const Color(0xFF7A5900),
          brightness: Brightness.dark,
        );
      }
      return MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: _isSignedIn ? const HomePage() : const LoginPage(),
      );
    });
  }

  void getLoggedInStatus() async {
    await SharedPreferencesState.getLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }
}
