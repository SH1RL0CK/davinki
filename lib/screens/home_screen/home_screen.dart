import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:DAVINKI/secret.dart' as secret;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hallo,\n${secret.name}!',
              style: TextStyle(fontSize: 35.0),
              textAlign: TextAlign.start,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text.rich(
                  TextSpan(
                    text: 'Heute ist der\n',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: formatDate(DateTime.now(), [dd, '.', mm, '.', yyyy]), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text.rich(
                  TextSpan(
                    text: 'Und es ist\n',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: '${formatDate(DateTime.now(), [HH, ':', nn])} Uhr', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Deine Kurse:',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Column(
              children: <Widget>[
                ...secret.mySubjects.map((subject) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(subject.color),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: 'Kurs ${subject.name}\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Lehrer: ${subject.teacher}',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
