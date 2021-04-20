import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserIsOfflineScreen extends StatelessWidget {
  const UserIsOfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Davinki',
          style: GoogleFonts.pacifico(fontSize: 25),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.wifi_off,
              size: 50,
            ),
            SizedBox(height: 5),
            Text(
              'Du bist offline, \n Bitte gehe online!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
