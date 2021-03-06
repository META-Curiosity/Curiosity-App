import 'package:flutter/material.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'dart:async';
import 'package:curiosity_flutter/services/notification_service.dart';

class ChooseMindfulnessSession extends StatefulWidget {
  const ChooseMindfulnessSession({Key key}) : super(key: key);

  @override
  _ChooseMindfulnessSessionState createState() =>
      _ChooseMindfulnessSessionState();
}

class _ChooseMindfulnessSessionState extends State<ChooseMindfulnessSession> {
  final List<String> images = <String>[
    "assets/images/morning.jpeg",
    "assets/images/noon.jpeg",
    "assets/images/night.jpeg"
  ];
  final List<String> info = <String>[
    "Morning: 8am - 12pm",
    "Afternoon: 12pm - 4pm",
    "Evening: 4pm - 8pm"
  ];

  // UserDbService UDS = UserDbService('hashedEmail');
  UserDbService UDS;
  User user = User();
  NotificationService notificationService;

  String _id;
  @override
  void didChangeDependencies() {
    String uuid = ModalRoute.of(context).settings.arguments as String;
    setState(() {
      _id = uuid;
      UDS = UserDbService(uuid);
      notificationService = NotificationService();
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
                        "   In this app, you will be asked to complete mindfulness activities.  Please choose when you would like to complete mindfulness sessions!",
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
                        "Choose your",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        "mindfulness session",
                        style: TextStyle(
                          fontSize: 32,
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
                          "Mindfulness Sessions",
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
                                            //TODO BACKEND: MORNING: 0, AFTERNOON: 1, EVENiNG:

                                            List<int> data = [];
                                            if (index == 0) {
                                              data = [8, 9, 10, 11, 12];
                                            } else if (index == 1) {
                                              data = [12, 13, 14, 15, 16];
                                            } else {
                                              data = [16, 17, 18, 19, 20];
                                            }
                                            // await UDS
                                            //     .updateMindfulReminders(data);
                                            await notificationService
                                                .scheduleMindfulnessSessionNotification(
                                                    data);
                                            Navigator.pushReplacementNamed(
                                                context, '/navigation',
                                                arguments: [_id, 0]);
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
