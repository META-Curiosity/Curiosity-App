import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionDailyChallenge extends StatelessWidget {
  const IntroductionDailyChallenge({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uuid = ModalRoute.of(context).settings.arguments as String;
    return SafeArea(
        child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: "You've been assigned a daily challenge!",
          body:
              "You have been assigned to complete a daily challenge rather than one of your personalized goals. "
              "These are activities that have been designed by researchers and proven to promote curiosity!",
          image: buildImage('assets/images/attention.jpeg'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Choose a level of intensity",
          body:
              "You may choose between three levels, from less time-consuming to more time-consuming. "
              "The higher the level, the more time you will commit, and the more you will grow and become curious!",
          image: buildImage('assets/images/challenge.jpeg'),
          decoration: getPageDecoration(),
          footer: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/task_carousel', arguments: uuid);
              },
              child: Text("Choose a daily challenge!")),
        )
      ],

      next: Icon(Icons.arrow_forward),
      dotsDecorator: getDotDecoration(),
      showDoneButton: false,
      // showSkipButton: true,
      // skip: Text("Skip"),
    ));
  }
}

Widget buildImage(String path) => Center(
        child: Image.asset(
      path,
      width: 350,
    ));

PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyTextStyle: TextStyle(fontSize: 20),
    descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: EdgeInsets.all(24),
    pageColor: Colors.white);

DotsDecorator getDotDecoration() =>
    DotsDecorator(size: Size(10, 10), activeSize: Size(15, 10));
