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
                user: user,
                id: '0'),
            const SizedBox(height: 15),
            GradientButton(
                startColor: Color(0xFFC34FE5),
                endColor: Color(0xFF8302A7),
                user: user,
                id: '1'),
            const SizedBox(height: 15),
            GradientButton(
                startColor: Color(0xFF74D5BF),
                endColor: Color(0xFF1B9D8D),
                user: user,
                id: '2'),
            const SizedBox(height: 15),
            GradientButton(
                startColor: Color(0xFFED9440),
                endColor: Color(0xFFDA5D03),
                user: user,
                id: '3'),
            const SizedBox(height: 15),
            GradientButton(
                startColor: Color(0xFFE9C216),
                endColor: Color(0xFFE2810B),
                user: user,
                id: '4'),
            const SizedBox(height: 15),
            GradientButton(
                startColor: Color(0xFF5C7CCA),
                endColor: Color(0xFF2741A6),
                user: user,
                id: '5'),
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

class dataToBePushed {
  final User user;
  final String id;

  const dataToBePushed(this.user, this.id);
}

class GradientButton extends StatefulWidget {
  Color startColor, endColor;
  User user;
  String id;
  GradientButton(
      {Color startColor, Color endColor, Key key, String id, User user})
      : super(key: key) {
    this.startColor = startColor;
    this.endColor = endColor;
    this.user = user;
    this.id = id;
  }

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  var title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 330,
        height: 60,
        child: RaisedButton(
            onPressed: () async {
              //Push the inputting task screen on top
              if (widget.user.customTasks[widget.id].title != null) {
                await Navigator.pushNamed(context, '/input_tasks',
                        arguments: dataToBePushed(widget.user, widget.id))
                    .then((_) => setState(() {}));
              } else {
                await Navigator.pushNamed(
                  context,
                  '/input_tasks',
                ).then((_) => setState(() {}));
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
                child: widget.user.customTasks[widget.id].title == null
                    ? SvgPicture.asset(
                        "assets/images/plus.svg",
                        semanticsLabel: 'Plus',
                      )
                    : Row(children: <Widget>[
                        SizedBox(width: 15),
                        Text(
                          widget.user.customTasks[widget.id].title,
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
