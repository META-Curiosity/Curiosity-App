import 'package:flutter/material.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'dart:async';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:curiosity_flutter/services/notification_service.dart';

class ChooseTaskSession extends StatefulWidget {
  const ChooseTaskSession({Key key}) : super(key: key);

  @override
  _ChooseMindfulnessSessionState createState() =>
      _ChooseMindfulnessSessionState();
}

class _ChooseMindfulnessSessionState extends State<ChooseTaskSession> {
  final List<String> images = <String>[
    "assets/images/morningCity.jpeg",
    "assets/images/noonCity.jpeg",
    "assets/images/eveningCity.jpeg"
  ];
  final List<String> info = <String>[
    "Morning: 9am - 12pm",
    "Afternoon: 12pm - 4pm",
    "Evening: 4pm - 9pm"
  ];

  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  String _id;

  //UserDbService UDS = UserDbService('hashedEmail');

  UserDbService UDS;
  User user = User();
  NotificationService notificationService;

  @override
  void didChangeDependencies() {
    String uuid = ModalRoute.of(context).settings.arguments as String;
    setState(() {
      _id = uuid;
      UDS = UserDbService(uuid);
      notificationService = NotificationService(uuid);
    });
    super.didChangeDependencies();
  }

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SizedBox(
                height: 160,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Container()),
                        IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                    Text(
                        "   Remembering is a hassle, so the app will do it for you!  Choose when you would like to be reminded to complete your tasks!",
                        style: TextStyle(
                          fontSize: 18,
                        ))
                  ],
                ),
              ),
              actions: <Widget>[]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.amber.withOpacity(.9), Colors.yellow[300]],
                    begin: const FractionalOffset(0.0, 0.4),
                    end: Alignment.topRight)),
            child: Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 30, left: 20, right: 30),
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Expanded(child: Container()),
                          IconButton(
                              icon: Icon(Icons.info_outline,
                                  size: 30, color: Colors.white),
                              onPressed: () async {
                                print("hello?");
                                return await showInformationDialog(context);
                              }),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Choose when you would like to be reminded to complete your task",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(40))),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 30.0),
                        Text(
                          "Task Notification Selection",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: 70),
                            Text(
                                "Please choose a time after now and before the day ends"),
                            SizedBox(height: 50),
                            SizedBox(
                              height: 50,
                              width: 200,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  MaterialCommunityIcons.clock_outline,
                                  size: 30.0,
                                ),
                                label: Text('SELECT TIME'),
                                onPressed: _selectTime,
                                style: ElevatedButton.styleFrom(),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Selected time: ${_time.format(context)}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 50),
                            SizedBox(
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  AntDesign.arrowright,
                                  size: 30.0,
                                ),
                                onPressed: () async {
                                  String time = _time.format(context);
                                  String zone = time.substring(
                                      time.length - 2, time.length);
                                  String minutes = time.substring(
                                      time.length - 5, time.length - 3);
                                  String hours;
                                  String convertedTime;
                                  if (time.length == 8) {
                                    hours = time.substring(0, 2);
                                  } else {
                                    hours = time.substring(0, 1);
                                  }
                                  if (zone == "AM") {
                                    if (hours == "12") {
                                      convertedTime = "00:" + minutes;
                                    } else if (hours == "10" || hours == "11") {
                                      convertedTime = hours + ":" + minutes;
                                    } else {
                                      convertedTime =
                                          "0" + hours + ":" + minutes;
                                    }
                                  } else if (zone == "PM") {
                                    if (hours == "12") {
                                      convertedTime = "12:" + minutes;
                                    } else {
                                      int hours24 = int.parse(hours) + 12;
                                      convertedTime =
                                          hours24.toString() + ":" + minutes;
                                    }
                                  }
                                  print(hours);
                                  print(zone);
                                  print(minutes);
                                  print("Converted Time = " + convertedTime);
                                  await notificationService
                                      .scheduleActivityCompletionNotification(
                                          convertedTime);
                                  Navigator.pushReplacementNamed(
                                      context, '/navigation',
                                      arguments: _id);
                                },
                                label: Text('CONTINUE'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ))
            ])));
  }
}
