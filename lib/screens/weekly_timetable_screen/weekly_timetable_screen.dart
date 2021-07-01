import 'package:davinki/models/course_settings.dart';
import 'package:davinki/models/general_settings.dart';
import 'package:davinki/screens/loading_screen/loading_screen.dart';
import 'package:davinki/screens/setting_screens/general_settings_screen/general_settings_screen.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/date_cell.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/weekly_timetable.dart';
import 'package:davinki/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeeklyTimetableScreen extends StatefulWidget {
  final Map<String, dynamic> _infoserverData;
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;
  final bool offline;
  const WeeklyTimetableScreen(
      this._infoserverData, this._generalSettings, this._courseSettings,
      {this.offline = false});
  @override
  _WeeklyTimetableScreenState createState() => _WeeklyTimetableScreenState(
      _infoserverData, offline, _generalSettings, _courseSettings);
}

class _WeeklyTimetableScreenState extends State<WeeklyTimetableScreen> {
  final Map<String, dynamic> _infoserverData;
  final bool _offline;
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;
  int _week = 0;
  bool _offlineSnackbarIsDisplayed = false;
  _WeeklyTimetableScreenState(
    this._infoserverData,
    this._offline,
    this._generalSettings,
    this._courseSettings,
  );

  @override
  void initState() {
    super.initState();
    if (_offline) _showOfflineSnackbar();
  }

  void _showOfflineSnackbar() {
    setState(() {
      _offlineSnackbarIsDisplayed = true;
    });

    WidgetsBinding.instance!.addPostFrameCallback((Duration timestamp) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              backgroundColor: Colors.red.shade800,
              duration: const Duration(seconds: 5),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Du bist offline!',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          )
          .closed
          .then(
        (dynamic reason) {
          setState(() {
            _offlineSnackbarIsDisplayed = false;
          });
        },
      );
    });
  }

  void _changeWeek(int i) {
    setState(() {
      if (!(i < 0 && _week <= -2)) {
        _week += i;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> datesOfWeek = getDatesOfWeek(_week);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Davinki',
          style: GoogleFonts.pacifico(fontSize: 25),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              navigateToOtherScreen(
                const LoadingScreen(),
                context,
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              navigateToOtherScreen(
                GeneralSettingsScreen(_generalSettings, _courseSettings),
                context,
              );
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Visibility(
              visible: _week > -2,
              child: FloatingActionButton(
                onPressed: () => _changeWeek(-1),
                mini: true,
                heroTag: null,
                child: const Icon(Icons.keyboard_arrow_left),
              ),
            ),
            FloatingActionButton(
              onPressed: () => _changeWeek(1),
              mini: true,
              heroTag: null,
              child: const Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          navigateToOtherScreen(
            const LoadingScreen(),
            context,
          );
        },
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  color: Colors.white,
                  padding: EdgeInsets.only(
                      bottom: _offlineSnackbarIsDisplayed ? 120 : 55),
                  child: WeeklyTimetable(
                    _week,
                    _infoserverData,
                    _courseSettings,
                    key: UniqueKey(),
                  ),
                ),
              ),
              Table(
                children: <TableRow>[
                  TableRow(
                    children: <TableCell>[
                          TableCell(
                            child: Container(),
                          ),
                        ] +
                        datesOfWeek
                            .map((DateTime date) => TableCell(
                                  child: DateCell(date),
                                ))
                            .toList(),
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                ],
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: const TableBorder(
                    bottom: BorderSide(color: Colors.black12)),
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(58),
                },
              ),
            ],
          ),
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity == 0) return;
            if (details.primaryVelocity!.compareTo(0) == -1) {
              _changeWeek(1);
            } else {
              _changeWeek(-1);
            }
          },
        ),
      ),
    );
  }
}
