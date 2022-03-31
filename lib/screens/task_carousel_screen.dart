import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_icons/flutter_icons.dart';

class TaskCarousel extends StatefulWidget {
  const TaskCarousel({Key key}) : super(key: key);

  @override
  _TaskCarouselState createState() => _TaskCarouselState();
}

class _TaskCarouselState extends State<TaskCarousel> {
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
  @override
  Widget build(BuildContext context) {
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
                height: 400,
                aspectRatio: 16 / 9,
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
                      child: TaskCard(
                        icon: Icon(cardIconList[i],
                            color: colorList[i], size: 52),
                        stat: 'w',
                        task: taskList[i],
                        color: colorList[i],
                        difficultyIcon: Icon(difficultyIconList[i],
                            color: colorList[i], size: 120),
                        difficultyLabel: difficultyLabelList[i],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  print(" ${difficultyLabelList[currentTask]} was chosen");
                  Navigator.pushReplacementNamed(context, '/navigation');
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
