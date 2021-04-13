import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:davinki/screens/loading_screen/loading_screen.dart';

class CoursesSettings extends StatefulWidget {
  final Map<String, dynamic> _infoserverData;
  CoursesSettings(this._infoserverData, {Key? key}) : super(key: key);

  @override
  _CoursesSettingsState createState() => _CoursesSettingsState(this._infoserverData);
}

class _CoursesSettingsState extends State<CoursesSettings> {
  final Map<String, dynamic> _infoserverData;

  _CoursesSettingsState(this._infoserverData) : super();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Davinki',
            style: GoogleFonts.pacifico(fontSize: 25),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingScreen()),
                  (Route route) => false,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
