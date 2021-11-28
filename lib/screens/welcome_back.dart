import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeBackScreen extends StatelessWidget {
  const WelcomeBackScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      color: Colors.amber,
      padding: const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 30),
      child: Column(
        children: <Widget>[
          const Text(
            'Sun, Nov 28',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            "Focus on progress, not perfection.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
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
                'Write about anything for 30 minutes.',
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
          const SizedBox(height: 20),
          const Text(
            "⏰ 8:30 PM",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 275,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF4B81EF),
              ),
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/set_custom_tasks');
              },
              child: const Text("I'm done!"),
            ),
          )
        ],
      ),
    ));
  }
}
