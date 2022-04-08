import 'package:curiosity_flutter/screens/input_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:collection';
import 'package:curiosity_flutter/models/user.dart';
import 'package:curiosity_flutter/models/custom_task.dart';
import 'package:curiosity_flutter/models/props.dart';
import 'package:curiosity_flutter/navigation.dart';

class DailyCustomTasksScreen extends StatefulWidget {
  const DailyCustomTasksScreen({Key key}) : super(key: key);
  @override
  State<DailyCustomTasksScreen> createState() => _DailyCustomTasksScreen();
}

class _DailyCustomTasksScreen extends State<DailyCustomTasksScreen> {
  //Function to check if all 6 tasks are completed or not.
  bool check() {
    final arg = ModalRoute.of(context).settings.arguments as List;
    String uuid = arg[0];
    User user = arg[1];
    for (int i = 0; i < 6; i++) {
      String key = i.toString();
      if (user.customTasks[key].title == null) {
        return false;
      }
    }
    return true;
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context).settings.arguments as List;
    String uuid = arg[0];
    User user = arg[1];
    return Center(
        child: Container(
      color: Colors.grey[200],
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      key: UniqueKey(),
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            const Text(
              'Choose Your Custom Goal',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text(
              "Let's choose a goal for today!",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            GradientButton(
              startColor: Color(0xFFF6744B),
              endColor: Color(0xFFDA3401),
              user: user,
              id: '0',
              notifyParent: refresh,
            ),
            const SizedBox(height: 25),
            GradientButton(
              startColor: Color(0xFFC34FE5),
              endColor: Color(0xFF8302A7),
              user: user,
              id: '1',
              notifyParent: refresh,
            ),
            const SizedBox(height: 25),
            GradientButton(
              startColor: Color(0xFF74D5BF),
              endColor: Color(0xFF1B9D8D),
              user: user,
              id: '2',
              notifyParent: refresh,
            ),
            const SizedBox(height: 25),
            GradientButton(
              startColor: Color(0xFFED9440),
              endColor: Color(0xFFDA5D03),
              user: user,
              id: '3',
              notifyParent: refresh,
            ),
            const SizedBox(height: 25),
            GradientButton(
              startColor: Color(0xFFE9C216),
              endColor: Color(0xFFE2810B),
              user: user,
              id: '4',
              notifyParent: refresh,
            ),
            const SizedBox(height: 25),
            GradientButton(
              startColor: Color(0xFF5C7CCA),
              endColor: Color(0xFF2741A6),
              user: user,
              id: '5',
              notifyParent: refresh,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    ));
  }
}

class GradientButton extends StatefulWidget {
  Function() notifyParent;
  Color startColor, endColor;
  User user;
  String id;
  GradientButton({
    Color startColor,
    Color endColor,
    Key key,
    String id,
    User user,
    Function() notifyParent,
  }) : super(key: key) {
    this.startColor = startColor;
    this.endColor = endColor;
    this.user = user;
    this.id = id;
    this.notifyParent = notifyParent;
  }

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  var title;

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context).settings.arguments as List;
    String uuid = arg[0];
    User user = arg[1];
    return SizedBox(
        width: 330,
        height: 60,
        child: RaisedButton(
            onPressed: () async {
              //Push the inputting task screen on top
              await Navigator.pushNamed(context, '/view_tasks',
                      arguments: [uuid, dataToBePushed(widget.user, widget.id)])
                  .then((_) => setState(() {
                        widget.notifyParent();
                      }));
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
