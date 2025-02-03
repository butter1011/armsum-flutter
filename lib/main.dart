import 'package:armsum/view/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flutter Theme Switcher',
          theme: themeProvider.themeData,
          home: const HomePage(),
        );
      },
    );
  }
}
