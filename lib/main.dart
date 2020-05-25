import 'package:flutter/material.dart';
import 'package:mliss/screens/Player.dart';

void main() {
  runApp(MlissApp());
}

class MlissApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mliss',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Player(),
    );
  }
}
