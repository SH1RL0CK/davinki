import 'package:flutter/material.dart';
import 'package:davinki/screens/loading_screen.dart';

void main() {
  runApp(DavinkiApp());
}

class DavinkiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DAVINKI',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoadingScreen(),
    );
  }
}
