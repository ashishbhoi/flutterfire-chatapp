import 'package:chatapp/pages/home_page.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme? lightColorScheme;
    ColorScheme? darkColorScheme;
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamicColor, ColorScheme? darkDynamicScheme) {
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
          home: const HomePage(),
        );
      }
    );
  }
}
