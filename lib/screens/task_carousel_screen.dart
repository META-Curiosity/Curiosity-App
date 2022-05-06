import 'package:curiosity_flutter/models/meta_task.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:curiosity_flutter/services/meta_task_db_service.dart';
import 'package:intl/intl.dart';
import 'package:curiosity_flutter/helper/date_parse.dart';
import 'dart:math';

class TaskCarousel extends StatefulWidget {
  const TaskCarousel({Key key}) : super(key: key);

  @override
  _TaskCarouselState createState() => _TaskCarouselState();
}

class _TaskCarouselState extends State<TaskCarousel>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 50));
    _animation = Tween(end: 2.0, begin: 0.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
      });
  }

  String _id;
  UserDbService UDS;
  List<MetaTask> tasks = List.filled(3, null);
  List<String> taskIdList = List.filled(3, null);

  @override
  void didChangeDependencies() async {
    final String uuid = ModalRoute.of(context).settings.arguments as String;
    setState(() {
      _id = uuid;
      UDS = UserDbService(uuid);
    });
    MetaTaskDbServices MTDS = new MetaTaskDbServices();
    for (int i = 0; i < difficultyLabelListDb.length; i++) {
      Map<String, dynamic> result =
          await UDS.getRandomMetaTask(difficultyLabelListDb[currentTask]);
      taskIdList[i] = result['taskId'].toString();
      await MTDS
          .getTaskByDifficultyAndID(difficultyLabelListDb[i], result['taskId'])
          .then((res) {
        tasks[i] = res['metaTask'];
      });
    }
  }

  int currentTask = 0;
  final taskList = [
    'Curiosity Teaser',
    'Curiosity Booster',
    'Curiosity Launchpad'
  ];
  final colorList = [Colors.lightBlue, Colors.yellow, Colors.red];
  final cardIconList = [
    MaterialCommunityIcons.truck_fast,
    MaterialCommunityIcons.airplane,
    FontAwesome.rocket
  ];
  final difficultyIconList = [
    MaterialCommunityIcons.speedometer_slow,
    MaterialCommunityIcons.speedometer_medium,
    MaterialCommunityIcons.speedometer
  ];
  final difficultyLabelList = ['Beginner', 'Intermediate', 'Advanced'];
  final difficultyLabelListDb = ['easy', 'intermediate', 'hard'];
  @override
  Widget build(BuildContext context) {
    // UserDbService UDS = UserDbService('hashedEmail');

    return Container(
        child: Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            SafeArea(
              child: Text(
                'Today\'s Task',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Text("Pick a level of difficulty to get started",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 40),
            CarouselSlider(
              options: CarouselOptions(
                height: 420,
                aspectRatio: 16 / 7,
                viewportFraction: 0.75,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                onPageChanged: (i, reason) {
                  // print("Page: ${i}");
                  // print("Reason: ${reason}");
                  setState(() {
                    currentTask = i;
                  });
                },
                scrollDirection: Axis.horizontal,
              ),
              items: [0, 1, 2].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      // decoration: BoxDecoration(color: Colors.amber),
                      child: Transform(
                        alignment: FractionalOffset.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.002)
                          ..rotateY(pi * _animation.value),
                        child: GestureDetector(
                          onTap: () {
                            if (_animationStatus == AnimationStatus.dismissed) {
                              _animationController.forward();
                            } else {
                              _animationController.reverse();
                            }
                          },
                          child: _animation.value <= 1.0
                              ? TaskCard(
                                  icon: Icon(cardIconList[i],
                                      color: colorList[i], size: 52),
                                  stat: 'w',
                                  task: taskList[i],
                                  color: colorList[i],
                                  difficultyIcon: Icon(difficultyIconList[i],
                                      color: colorList[i], size: 120),
                                  difficultyLabel: difficultyLabelList[i],
                                )
                              : DescriptionCard(
                                  title: tasks[i].title,
                                  description: tasks[i].description,
                                  color: colorList[i],
                                ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> data = {
                    'id': datetimeToString(DateTime.now()),
                    'taskTitle': tasks[currentTask].title,
                    'isCustomTask': false,
                    'taskId': taskIdList[currentTask],
                    'taskDifficulty': difficultyLabelListDb[currentTask]
                  };

                  await UDS.addDailyEvalMorningEvent(data);

                  Navigator.pushReplacementNamed(
                      context, '/choose_task_session',
                      arguments: _id);
                },
                child: Text(
                  'Continue',
                  style: TextStyle(color: Color(0xffFFFFFF), fontSize: 20),
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )),
                    // backgroundColor:
                    //     MaterialStateProperty.all<Color>(Colors.amber),
                    fixedSize: MaterialStateProperty.all(Size(300, 48))))
          ]),
    ));
  }
}

class TaskCard extends StatefulWidget {
  final String task; //name of the task
  final Icon icon; //Icon identifying the card
  final String stat; //statistic of the record
  final Color color; //Color of the card
  final Icon difficultyIcon; //difficulty icon
  final String difficultyLabel; //label of difficulty
  //Constructor
  const TaskCard({
    Key key,
    @required this.icon,
    @required this.stat,
    @required this.task,
    @required this.color,
    @required this.difficultyIcon,
    @required this.difficultyLabel,
  }) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 2.2,
        color: Colors.grey[700],
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20),
                Text(widget.task,
                    style: TextStyle(
                        fontSize: 28,
                        color: widget.color,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: widget.icon),
                SizedBox(height: 20),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: widget.difficultyIcon),
                SizedBox(height: 10),
                Text(widget.difficultyLabel,
                    style: TextStyle(
                        fontSize: 24,
                        color: widget.color,
                        fontWeight: FontWeight.bold)),
              ]),
        ),
      ),
    );
  }
}

class DescriptionCard extends StatefulWidget {
  final String title; //name of the task
  final String description; //name of the task
  final Color color; //Color of the card

  //Constructor
  const DescriptionCard({
    Key key,
    @required this.title,
    @required this.description,
    @required this.color,
  }) : super(key: key);

  @override
  _DescriptionCardState createState() => _DescriptionCardState();
}

class _DescriptionCardState extends State<DescriptionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 2.2,
        color: Colors.grey[700],
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(widget.title,
                      style: TextStyle(
                          fontSize: 20,
                          color: widget.color,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(widget.description,
                      style: TextStyle(
                          height: 1.15,
                          fontSize: 14,
                          color: widget.color,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10),
              ]),
        ),
      ),
    );
  }
}
