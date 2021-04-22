import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SetCustomTasksScreen extends StatelessWidget {
  const SetCustomTasksScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: const EdgeInsets.only(top: 160, left: 30, right: 30, bottom: 30),
      child: Column(
        children: <Widget>[
          const Text(
            'Set Your Custom Tasks',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            "Let's set 6 goals related to curiosity.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 84),
          SvgPicture.asset('assets/images/edit.svg',
              semanticsLabel: 'Pencil editing a book', height: 200),
          const SizedBox(height: 144),
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
              child: const Text("Continue"),
            ),
          )
        ],
      ),
    ));
  }
}
