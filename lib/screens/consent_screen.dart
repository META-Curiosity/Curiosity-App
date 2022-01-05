import 'package:flutter/material.dart';

class Consent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        SizedBox(height: 130),
        SizedBox(
          width: MediaQuery.of(context).size.width - 50.0,
          child: ElevatedButton(
              onPressed: () {},
              child: Text('Allow'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[700],
                elevation: 0,
              )),
        ),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 50.0,
            child: ElevatedButton(
                onPressed: () {},
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
