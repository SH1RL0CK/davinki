import 'package:flutter/material.dart';
import 'package:davinki/screens/loading_screen/loading_screen.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(DavinkiApp());
}

class DavinkiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Davinki',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoadingScreen(),
    );
  }
}
