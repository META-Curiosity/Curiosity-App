import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class WelcomeBackScreen extends StatefulWidget {
  String date; //Current date
  String task; //Today's task
  String uuid; //User id
  WelcomeBackScreen(
      {Key key, @required this.date, @required this.task, @required this.uuid})
      : super(key: key);

  @override
  State<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Center(
        child: Column(
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
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            // const SizedBox(height: 84),
            // SvgPicture.asset('assets/images/edit.svg',
            //     semanticsLabel: 'Pencil editing a book', height: 200),
            const SizedBox(height: 30),
            const Text(
              "⏰ 8:30 PM",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
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
                      arguments: widget.uuid);
                },
                child: const Text("I'm done!"),
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
            )
          ],
        ),
      ),
    );
  }
}
