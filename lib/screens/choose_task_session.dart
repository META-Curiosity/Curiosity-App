import 'package:flutter/material.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'dart:async';

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
                        "   Remembering is pain, so the app will do it for you!  Choose when you would like to be reminded to complete your tasks!",
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
                    colors: [Colors.amber.withOpacity(.8), Colors.yellow[300]],
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
                        "Choose when you would like to be reminded to complete tasks",
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
                          "Task Reminder Sessions",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(10.0, 10, 0, 0),
                            itemCount: 3,
                            itemBuilder: (_, int index) {
                              return GestureDetector(
                                onTap: () {
                                  print(index);
                                  debugPrint(index.toString());
                                },
                                child: Container(
                                  height: 135,
                                  //color: Colors.red,
                                  width: 200,
                                  child: Column(
                                    children: <Widget>[
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              elevation: 5.0),
                                          onPressed: () async {
                                            List<int> data = [];
                                            if (index == 0) {
                                              data = [9, 10, 11, 12];
                                            } else if (index == 1) {
                                              data = [12, 13, 14, 15, 16];
                                            } else {
                                              data = [16, 17, 18, 19, 20, 21];
                                            }
                                            await UDS
                                                .updateMindfulReminders(data);
                                            Map<String, dynamic> d =
                                                await UDS.getUserData();
                                            if (d["user"].mindfulEligibility) {
                                              Navigator.pushNamed(context,
                                                  '/choose_mindfulness_session');
                                            } else {
                                              Navigator.pushNamed(
                                                  context, '/onboarding');
                                            }
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              images[index]))),
                                                ),
                                              ),
                                              Container(
                                                  width: 250,
                                                  height: 60,
                                                  child: Center(
                                                    child: Text(info[index],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18.0)),
                                                  )),
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            }))
                  ],
                ),
              ))
            ])));
  }
}
