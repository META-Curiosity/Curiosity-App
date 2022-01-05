import 'package:flutter/material.dart';

class StudyId extends StatefulWidget {
  const StudyId({Key key}) : super(key: key);

  @override
  _StudyIdState createState() => _StudyIdState();
}

class _StudyIdState extends State<StudyId> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 50),
        Text("Taking part in the Curiosity Study?",
            style: TextStyle(fontSize: 52))
      ],
    ));
  }
}
