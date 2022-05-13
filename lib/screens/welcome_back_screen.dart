import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curiosity_flutter/navigation.dart';
import 'package:intl/intl.dart';
import 'package:curiosity_flutter/models/daily_evaluation.dart';

class WelcomeBackScreen extends StatefulWidget {
  String date; //Current date
  String task; //Today's task
  String uuid; //User id
  int taskStatus; // true if user finished/skip task for today
  String description;
  WelcomeBackScreen({
    Key key,
    @required this.date,
    @required this.task,
    @required this.uuid,
    @required this.taskStatus,
    @required this.description,
  }) : super(key: key);

  @override
  State<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  @override
  Widget build(BuildContext context) {
    //Dialog for description of task
    Dialog errorDialog = Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), //this right here
        child: SingleChildScrollView(
          child: Expanded(
            child: Container(
              height: 400.0,
              width: 300.0,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Text(
                        widget.description,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 40.0)),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Got It!',
                          style:
                              TextStyle(color: Colors.purple, fontSize: 18.0),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ));
    return Container(
      color: Colors.amber,
      child: Center(
        child: (widget.taskStatus == -1)
            ? Column(
                children: <Widget>[
                  const SizedBox(height: 100),
                  Text(
                    widget.date,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Focus on progress, not perfection.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      print(widget.description);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => errorDialog);
                    },
                    child: Container(
                      // margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(10.0),
                      height: 170,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: Colors.black,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      child: Center(
                        child: Text(
                          widget.task,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  SizedBox(
                    width: 275,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF4B81EF),
                      ),
                      onPressed: () {
                        // Navigate to the second screen using a named route.
                        Navigator.pushNamed(context, '/activity_survey',
                                arguments: widget.uuid)
                            .then((_) => setState(() {}));
                      },
                      child: const Text("Mark goal as complete."),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 275,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[600],
                      ),
                      onPressed: () {
                        // Navigate to the second screen using a named route.
                        Navigator.pushNamed(context, '/nightly_evaluation_no',
                            arguments: widget.uuid);
                      },
                      child: const Text("Skip today's goal."),
                    ),
                  ),
                ],
              )
            : Column(
                children: <Widget>[
                  const SizedBox(height: 100),
                  Text(
                    widget.date,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Focus on progress, not perfection.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    // margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(10.0),
                    height: 170,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.black,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    child: Center(
                      child: Text(
                        widget.task,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  (widget.taskStatus == 0)
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: SizedBox(
                            child: Text(
                              'Its all good, next time will\nbe successful! ✅',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5),
                            ),
                          ),
                        )
                      : Text(''),
                  (widget.taskStatus == 1)
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: SizedBox(
                            child: Text(
                              'Congrats on completing your daily goal.\n\n  Stay Curious! 🎉',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                  height: 1.25),
                            ),
                          ),
                        )
                      : Text('')
                ],
              ),
      ),
    );
  }
}
