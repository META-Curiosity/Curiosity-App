import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SetCustomTasksScreen extends StatelessWidget {
  const SetCustomTasksScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
      child: Column(
        children: <Widget>[
          const Text(
            'Set Your Custom Tasks',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          const Text(
            "Let's set 6 goals related to curiosity.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          GradientButton(
              startColor: Color(0xFFF6744B), endColor: Color(0xFFDA3401)),
          const SizedBox(height: 15),
          GradientButton(
              startColor: Color(0xFF8E8E92), endColor: Color(0xFF2D2D2D)),
          const SizedBox(height: 15),
          GradientButton(
              startColor: Color(0xFF8E8E92), endColor: Color(0xFF2D2D2D)),
          const SizedBox(height: 15),
          GradientButton(
              startColor: Color(0xFF8E8E92), endColor: Color(0xFF2D2D2D)),
          const SizedBox(height: 15),
          GradientButton(
              startColor: Color(0xFF8E8E92), endColor: Color(0xFF2D2D2D)),
          const SizedBox(height: 15),
          GradientButton(
              startColor: Color(0xFF8E8E92), endColor: Color(0xFF2D2D2D)),
          const SizedBox(height: 60),
          SizedBox(
            width: 330,
            height: 60,
            child: RaisedButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              color: Color(0xFF8E8E92),
              padding: const EdgeInsets.all(0.0),
              child: Container(
                  constraints: const BoxConstraints(
                      minWidth: 88.0,
                      minHeight: 36.0), // min sizes for Material buttons
                  alignment: Alignment.center,
                  child: Text(
                    "Continue",
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Not Now",
            style: new TextStyle(fontSize: 20.0, color: Color(0xFF3A82F7)),
          )
        ],
      ),
    ));
  }
}

class GradientButton extends StatelessWidget {
  Color startColor, endColor;

  GradientButton({
    Color startColor,
    Color endColor,
    Key key,
  }) : super(key: key) {
    this.startColor = startColor;
    this.endColor = endColor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      height: 60,
      child: RaisedButton(
        onPressed: () {},
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[startColor, endColor], // red to yellow
              tileMode:
                  TileMode.repeated, // repeats the gradient over the canvas
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Container(
            constraints: const BoxConstraints(
                minWidth: 88.0,
                minHeight: 36.0), // min sizes for Material buttons
            alignment: Alignment.center,
            child: SvgPicture.asset(
              "assets/images/plus.svg",
              semanticsLabel: 'Plus',
            ),
          ),
        ),
      ),
    );
  }
}
