import 'package:flutter/material.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'dart:async';

class Consent extends StatefulWidget {
  @override
  State<Consent> createState() => _ConsentState();
}

class _ConsentState extends State<Consent> {
  // UserDbService UDS = UserDbService('hashedEmail');
  UserDbService UDS;
  User user = User();

  String _id;

  @override
  void didChangeDependencies() {
    List arg = ModalRoute.of(context).settings.arguments as List;
    String uuid = arg[0];
    setState(() {
      _id = uuid;
      UDS = UserDbService(uuid);
    });
    super.didChangeDependencies();
  }

  void navigateBasedOnStudyId(BuildContext context, String studyId) {
    int convertedStudyId = int.parse(studyId);
    if (convertedStudyId % 2 == 0)
      Navigator.pushReplacementNamed(context, '/choose_mindfulness_session',
          arguments: _id);
    else
      Navigator.pushReplacementNamed(context, '/introduction', arguments: _id);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as List;
    String _id = args[0];
    String studyId = args[1];
    print(studyId);

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 80),
        Image.asset('assets/images/circleData.png', scale: 3),
        SizedBox(height: 30),
        Text(
          "Data Consent",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
          child: Text(
            "   We value your privacy, so when you use this app, your personal data will be anonymous.\n\n"
            "   Do you consent to contribute your anonymized data to science?",
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(height: 60),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width - 50.0,
          child: ElevatedButton(
              onPressed: () async {
                await UDS.updateUserConsent(true);
                navigateBasedOnStudyId(context, studyId);
              },
              child: Text('Allow'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[700],
                elevation: 0,
              )),
        ),
        SizedBox(height: 30),
        Center(
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width - 50.0,
            child: ElevatedButton(
                onPressed: () async {
                  await UDS.updateUserConsent(false);
                  navigateBasedOnStudyId(context, studyId);
                },
                child: Text(
                  'Decline',
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
    ));
  }
}
