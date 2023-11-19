import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:comic_creator/home/screens/home_screen.dart';
import 'package:comic_creator/theme/pallete.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // enclosing run app with riverpod
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Creator Comic : Dashtoon',
      theme: Pallete.getAppTheme(context),
      home: const HomeScreen(),
    );
  }
}
