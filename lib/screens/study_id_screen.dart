import 'package:flutter/material.dart';
import 'package:curiosity_flutter/screens/consent_screen.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'dart:async';

import '../main.dart';

class StudyId extends StatefulWidget {
  const StudyId({Key key})
      : super(
          key: key,
        );

  @override
  _StudyIdState createState() => _StudyIdState();
}

class _StudyIdState extends State<StudyId> {
  String _id;

  //UserDbService UDS = UserDbService('hashedEmail');

  UserDbService UDS;
  User user = User();

  @override
  void didChangeDependencies() {
    String uuid = ModalRoute.of(context).settings.arguments as String;
    setState(() {
      _id = uuid;
      UDS = UserDbService(uuid);
    });
    super.didChangeDependencies();
  }

  Future<void> showInformationDialog(BuildContext context) async {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _textEditingController =
              TextEditingController();
          return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _textEditingController,
                    validator: (value) {
                      return value.isNotEmpty ? null : "Enter Study ID";
                    },
                    decoration: InputDecoration(hintText: "Study ID"),
                  )),
              actions: <Widget>[
                TextButton(
                    child: Text('Exit'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                TextButton(
                    child: Text('Submit'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await UDS.updateUserLabId(
                            int.parse(_textEditingController.text));
                        Navigator.pushNamed(context, '/consent',
                            arguments: [_id, _textEditingController.text]);
                      }
                    })
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 70),
          Image.asset('assets/images/lightbulb.png', scale: 3),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 2.0, 0.0),
            child: Text(
              "Participating in the Curiosity Study?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
            child: Text(
              "   Whether you are using the Curiosity app to support scientific research or for your own personal goals, this app "
              "will help you become the best version of yourself!\n\n    If you are taking part in the Curiosity study, please enter your study id below.",
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 100),
          SizedBox(
            width: MediaQuery.of(context).size.width - 50.0,
            child: ElevatedButton(
                onPressed: () async {
                  return await showInformationDialog(context);
                },
                child: Text('Enter Study ID'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[700],
                  elevation: 0,
                )),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 50.0,
              child: ElevatedButton(
                  onPressed: () async {
                    await UDS.updateUserLabId(-1);
                    Navigator.pushNamed(context, '/consent',
                        arguments: [_id, '-1']);
                  },
                  child: Text(
                    'I\'m not participating in the study',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(color: Colors.grey[700])))),
            ),
          )
        ],
      )),
    );
  }
}
