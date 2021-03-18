import 'package:flutter/material.dart';

import 'pages/SplashPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //initializeDateFormatting();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Assis',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: const Color(0xFFff9800),
          accentColor: const Color(0xFFff9800),
          canvasColor: const Color(0xFFfafafa),
          primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white))),
      home: SplashPage(),
    );
  }
}
