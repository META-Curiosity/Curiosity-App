import 'package:curiosity_flutter/models/nightly_evaluation.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';

class CentralDashboardScreen extends StatefulWidget {
  const CentralDashboardScreen({Key key}) : super(key: key);

  @override
  _CentralDashboardScreenState createState() => _CentralDashboardScreenState();
}

class _CentralDashboardScreenState extends State<CentralDashboardScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay;
  List<NightlyEvaluation> _ne = [];
  List<DateTime> _dates = [];
  bool _dataRecieved = false;

  final PageController _pageController = PageController();
  DateTime today = DateTime.now();

  //Takes the currentMonth and returns a list of nightly evaluation from firestore under the user's collection.
  Future<List<NightlyEvaluation>> getDates(DateTime currentMonth) async {
    UserDbService UDS = UserDbService(
        '22528fa0c5fb066c90c256cc2113a5f6a74012ff6240a3fca6f74343525645dd');
    String convertedTime =
        '${currentMonth.month.toString().padLeft(2, '0')}-31-${currentMonth.year.toString().substring(2, 4)}'; //MM-DD-YYYY
    Map<String, dynamic> datesObj =
        await UDS.getUserNightlyEvalDatesByMonth(convertedTime);
    return datesObj['nightEvalRecords'];
  }

  //Takes a String date in the form MM-DD-YY and converts it into a DateTime object.
  DateTime stringToDateTime(String date) {
    List<String> dateSplit = date.split('-');
    return DateTime.utc(int.parse(dateSplit[2]), int.parse(dateSplit[0]),
        int.parse(dateSplit[1]));
  }

  //Takes in a List of Nightly Evaluations and returns a list of extracted DateTime
  List<DateTime> listOfNightlyEvaluationsToListOfDateTime(
      List<NightlyEvaluation> neList) {
    List<DateTime> dates = [];
    for (NightlyEvaluation ne in neList) {
      dates.add(stringToDateTime(ne.id));
    }
    return dates;
  }

  //
  List<DateTime> getEvents(DateTime d) {
    print("From getEvents: _dates${d}\n");
    if (_dates.contains(d)) print("HERE");
    //return null;
    return _dates;
  }

  void initState() {
    print("INITIALIZING..");
    //get list of nightly evaluations
    getDates(today).then((result) {
      setState(() {
        _ne = result; //Set list of nightly Evaluations
        _dates = listOfNightlyEvaluationsToListOfDateTime(
            result); //Set list of dates
        _dataRecieved = true; //Set Data Recieved to true
      });
    });

    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   print("length2: ${ne ?? 'null'}");
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: _dataRecieved
            ? Column(children: <Widget>[
                TableCalendar(
                  firstDay: DateTime.utc(2021, 12, 1),
                  lastDay: DateTime.utc(2021, 12, 30),
                  focusedDay: DateTime.now(),
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    // Use `selectedDayPredicate` to determine which day is currently selected.
                    // If this returns true, then `day` will be marked as selected.

                    // Using `isSameDay` is recommended to disregard
                    // the time-part of compared DateTime objects.
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      // Call `setState()` when updating the selected day
                      print("test: ${_dates ?? 'null'}");
                      setState(() {
                        _selectedDay = selectedDay;
                      });
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      // Call `setState()` when updating calendar format
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    // No need to call `setState()` here
                    //_focusedDay = focusedDay;
                  },
                  onCalendarCreated: (_pageController) {},
                  eventLoader: (d) {
                    //return _dates;
                    return getEvents(d);
                  },
                  //Style the Calendar
                  calendarStyle: CalendarStyle(
                      cellMargin: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                  headerStyle: HeaderStyle(
                    formatButtonShowsNext: false,
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    titleCentered: true,
                    formatButtonVisible: false,
                    headerPadding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    titleTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  'Records',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(children: <Widget>[
                  recordCard(
                      icon: Icon(MaterialCommunityIcons.calendar_check,
                          color: Colors.pink[300], size: 52),
                      stat: '18',
                      title: "Days in November"),
                  recordCard(
                      icon: Icon(Icons.check_circle,
                          color: Colors.green[400], size: 52),
                      stat: '18',
                      title: "Total Days Done"),
                ]),
                Row(children: <Widget>[
                  recordCard(
                      icon: Icon(MaterialCommunityIcons.fire,
                          color: Colors.orange[700], size: 52),
                      stat: '0',
                      title: "Current Streak"),
                  recordCard(
                      icon: Icon(MaterialCommunityIcons.crown,
                          color: Colors.yellow[600], size: 52),
                      stat: '18',
                      title: "Best Streak"),
                ]),
              ])
            : Text(''),
      ),
    );
  }
}

class recordCard extends StatefulWidget {
  final String title; //name of the record
  final Icon icon; //Icon displaying the record
  final String stat; //statistic of the record

  //Constructor
  const recordCard(
      {Key key, @required this.icon, @required this.stat, @required this.title})
      : super(key: key);

  @override
  _recordCardState createState() => _recordCardState();
}

class _recordCardState extends State<recordCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Card(
            elevation: 2.2,
            color: Colors.grey[200],
            margin: EdgeInsets.all(10),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: widget.icon),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(55, 0, 0, 10),
                          child: Text(
                            widget.stat,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 52),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Text('Days',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[700],
                                  fontSize: 16)),
                        )
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child:
                            Text(widget.title, style: TextStyle(fontSize: 16))),
                  ]),
            )),
      ),
    );
  }
}
