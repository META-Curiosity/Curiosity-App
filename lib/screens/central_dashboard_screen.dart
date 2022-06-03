import 'package:curiosity_flutter/models/daily_evaluation.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:curiosity_flutter/screens/set_custom_tasks_screen.dart';
import 'package:curiosity_flutter/screens/onboarding_screen.dart';

class CentralDashboardScreen extends StatefulWidget {
  Map<DateTime, List<DailyEvaluation>> dates;
  Map<String, dynamic> records;
  CentralDashboardScreen(
      {Key key, @required this.dates, @required this.records})
      : super(key: key);

  @override
  _CentralDashboardScreenState createState() => _CentralDashboardScreenState();
}

class _CentralDashboardScreenState extends State<CentralDashboardScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay;
  final PageController _pageController = PageController();
  DateTime today = DateTime.now();

  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //For each day, returns the nightly evaluation for that day.
    List<DailyEvaluation> getEvents(DateTime d) {
      if (d.day <= DateTime.now().day) {
        if (widget.dates[d] == null) {
          Map<String, dynamic> data = {'id': 'failed'};
          List<DailyEvaluation> temp = [new DailyEvaluation.fromData(data)];
          return temp;
        }
        return widget.dates[d];
      }
    }

    return Scaffold(
      body: Container(
        color: Colors.amber,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            SizedBox(height: 30.0),
            // Text(
            //   'Calendar',
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.amber,
                    width: 10,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.grey[200]),
              child: TableCalendar(
                firstDay:
                    DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
                lastDay:
                    DateTime.utc(DateTime.now().year, DateTime.now().month, 31),
                focusedDay: DateTime.now(),
                calendarFormat: _calendarFormat,
                // selectedDayPredicate: (day) {
                //   // Use `selectedDayPredicate` to determine which day is currently selected.
                //   // If this returns true, then `day` will be marked as selected.
                //
                //   // Using `isSameDay` is recommended to disregard
                //   // the time-part of compared DateTime objects.
                //   return isSameDay(_selectedDay, day);
                // },
                // onDaySelected: (selectedDay, focusedDay) {
                //   if (!isSameDay(_selectedDay, selectedDay)) {
                //     // Call `setState()` when updating the selected day
                //     setState(() {
                //       _selectedDay = selectedDay;
                //     });
                //     print("Day Log: ${widget.dates[selectedDay]}");
                //   }
                // },
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
                calendarBuilders: CalendarBuilders(
                    singleMarkerBuilder: (context, date, event) {
                  //Market is green or red depending on task completion that day.
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    color: (event.id == "failed") ? Colors.red : Colors.green,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  );
                }),
                eventLoader: (d) {
                  //return _dates;
                  return getEvents(d);
                },
                //Style the Calendar
                calendarStyle:
                    CalendarStyle(cellMargin: EdgeInsets.fromLTRB(0, 0, 0, 0)),
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
            ),
            SizedBox(height: 20),
            Text(
              'Records',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(children: <Widget>[
              recordCard(
                  icon: Icon(MaterialCommunityIcons.fire,
                      color: Colors.orange[700], size: 52),
                  stat: widget.records["currentStreak"].toString(),
                  //stat: "2",
                  title: "Current Streak"),
              recordCard(
                  icon: Icon(Icons.check_circle,
                      color: Colors.green[400], size: 52),
                  stat: widget.records["totalSuccessfulDays"].toString(),
                  //stat: "2",
                  title: "Goals completed"),
            ]),
            Row(children: <Widget>[
              recordCard(
                  icon: Icon(FontAwesome.leaf,
                      color: Colors.green[700], size: 52),
                  stat: '18',
                  title: "Mindful completion"),
              recordCard(
                  icon: Icon(MaterialCommunityIcons.calendar_check,
                      color: Colors.pink[300], size: 52),
                  stat: "18",
                  title: "Days In Program"),
            ]),
          ]),
        ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
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

//Unused RecordCards
//   recordCard(
//       icon: Icon(MaterialCommunityIcons.crown,
//           color: Colors.yellow[600], size: 52),
//       stat: '18',
//       title: "Best Streak"),
// recordCard(
//     icon: Icon(MaterialCommunityIcons.calendar_check,
//         color: Colors.pink[300], size: 52),
//     stat: "18",
//     title: "Days in November"),
