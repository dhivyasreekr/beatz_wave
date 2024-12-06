import 'package:beatz_wave/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:beatz_wave/screens/HomeScreen.dart';
import 'package:provider/provider.dart';

void main() {
  // runApp(const MyApp());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        routes: {
          '/home': (context) => HomeScreen(title: 'Home'),
        },
      ),
    );
  }
}
