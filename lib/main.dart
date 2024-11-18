import 'package:beatz_wave/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:beatz_wave/screens/HomeScreen.dart';
import 'package:provider/provider.dart';

void main() {
  // runApp(const MyApp());

  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(title: 'home')
    );
  }
}
