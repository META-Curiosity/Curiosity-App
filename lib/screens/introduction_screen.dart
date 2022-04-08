import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Introduction extends StatelessWidget {
  const Introduction({Key key}) : super(key: key);
  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SizedBox(
                height: 160,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Container()),
                        IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                    Text(
                        "Each time you complete a daily goal you move one step closer to becoming a more curious person- "
                        "small, consistent practice leads to stable long-term changes!",
                        style: TextStyle(
                          fontSize: 17,
                        ))
                  ],
                ),
              ),
              actions: <Widget>[]);
        });
  }

  @override
  Widget build(BuildContext context) {
    String uuid = ModalRoute.of(context).settings.arguments as String;
    return SafeArea(
        child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: "What are personalized goals?",
          body: "Personalized goals are specific and realistic"
              " behavioral goals that you will create to increase daily experiences of curiosity.",
          image: buildImage('assets/images/goals.jpeg'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
            title: "Becoming a more curious person",
            body:
                "These daily experiences of curiosity accumulate over time to form habits – stable, long-term changes in your personality!",
            image: buildImage('assets/images/curiosity.jpeg'),
            decoration: getPageDecoration(),
            footer: ElevatedButton(
                onPressed: () async {
                  return await showInformationDialog(context);
                },
                child: Text("Examples and Tips!")))
      ],
      done:
          Text('Skip to Goals', style: TextStyle(fontWeight: FontWeight.bold)),
      onDone: () {
        Navigator.of(context)
            .pushReplacementNamed('/onboarding', arguments: uuid);
      },
      next: Icon(Icons.arrow_forward),
      dotsDecorator: getDotDecoration(),
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
