import 'package:flutter/material.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'dart:async';
import 'package:flutter_icons/flutter_icons.dart';

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

  UserDbService UDS = UserDbService('hashedEmail');
  User user = User();
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
                            SizedBox(height: 120),
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
                            ),
                            SizedBox(height: 50),
                            SizedBox(
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  AntDesign.arrowright,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/navigation',
                                  );
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
