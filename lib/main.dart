import 'package:flutter/material.dart';
import 'package:potbelly/screens/splash_screen.dart';
import 'package:potbelly/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(context),
      home: SplashScreen(),
    );
  }
}
