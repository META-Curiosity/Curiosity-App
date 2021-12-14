import 'package:curiosity_flutter/screens/input_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:collection';
import 'package:curiosity_flutter/models/user.dart';
import 'package:curiosity_flutter/models/custom_task.dart';

class SetCustomTasksScreen extends StatefulWidget {
  const SetCustomTasksScreen({Key key}) : super(key: key);

  @override
  State<SetCustomTasksScreen> createState() => _SetCustomTasksScreenState();
}

class _SetCustomTasksScreenState extends State<SetCustomTasksScreen> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as User;
    final Map<String, CustomTask> customTasks = user.customTasks;
    print(customTasks['0'].toString());
    return Center(
        child: Container(
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
      child: SingleChildScrollView(
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
                startColor: Color(0xFFF6744B),
                endColor: Color(0xFFDA3401),
                content: customTasks['0']),
            const SizedBox(height: 15),
            GradientButton(
                startColor: Color(0xFFC34FE5),
                endColor: Color(0xFF8302A7),
                content: customTasks['1']),
            const SizedBox(height: 15),
            GradientButton(
                startColor: Color(0xFF74D5BF),
                endColor: Color(0xFF1B9D8D),
                content: customTasks['2']),
            const SizedBox(height: 15),
            GradientButton(
                startColor: Color(0xFFED9440),
                endColor: Color(0xFFDA5D03),
                content: customTasks['3']),
            const SizedBox(height: 15),
            GradientButton(
                startColor: Color(0xFFE9C216),
                endColor: Color(0xFFE2810B),
                content: customTasks['4']),
            const SizedBox(height: 15),
            GradientButton(
                startColor: Color(0xFF5C7CCA),
                endColor: Color(0xFF2741A6),
                content: customTasks['5']),
            const SizedBox(height: 50),
            SizedBox(
              width: 330,
              height: 60,
              child: RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/central_dashboard');
                },
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
      ),
    ));
  }
}

class GradientButton extends StatefulWidget {
  Color startColor, endColor;
  CustomTask content;
  GradientButton(
      {Color startColor,
      Color endColor,
      Key key,
      String id,
      CustomTask content})
      : super(key: key) {
    this.startColor = startColor;
    this.endColor = endColor;
    this.content = content;
  }

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  var title;
  @override
  Widget build(BuildContext context) {
    print(
        "content: ${widget.content.toString()}\n startColor: ${widget.startColor}");
    return SizedBox(
        width: 330,
        height: 60,
        child: RaisedButton(
            onPressed: () async {
              //Push the inputting task screen on top
              if (widget.content != null) {
                Navigator.pushNamed(context, '/input_tasks',
                    arguments: widget.content);
              } else {
                await Navigator.pushNamed(
                  context,
                  '/input_tasks',
                );
              }
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            padding: const EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    widget.startColor,
                    widget.endColor
                  ], // red to yellow
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
                child: widget.content == null
                    ? SvgPicture.asset(
                        "assets/images/plus.svg",
                        semanticsLabel: 'Plus',
                      )
                    : Row(children: <Widget>[
                        SizedBox(width: 15),
                        Text(
                          widget.content.title,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.more_horiz, size: 35.0, color: Colors.white)
                      ]),
              ),
            )));
  }
}
