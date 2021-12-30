import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AudioPlayer extends StatelessWidget {
  const AudioPlayer({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: const EdgeInsets.only(top: 160, left: 30, right: 30, bottom: 30),
      child: Column(
        children: <Widget>[
          const Text(
            'Mindful Sessions',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Audio recordings for mindful eating, walking, or washing.',
            style: TextStyle(fontSize: 16),
          ),
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
                Navigator.pushNamed(context, '/play_audio');
              },
              child: const Text("Set Today's Task"),
            ),
          )
        ],
      ),
    ));
  }
}
