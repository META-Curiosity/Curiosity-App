import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoodMorningScreen extends StatelessWidget {
  const GoodMorningScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
          child: Container(
        color: Colors.amber,
        padding: const EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Good morning',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "It's time to set your goals for today.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 84),
              SvgPicture.asset('assets/images/target.svg',
                  semanticsLabel: 'Target', height: 200),
              const SizedBox(height: 60),
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
        ),
      )),
    );
  }
}
