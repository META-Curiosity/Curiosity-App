import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';

class IntroductionTask extends StatelessWidget {
  IntroductionTask({Key key}) : super(key: key);
  UserDbService UDS = UserDbService('hashedEmail');

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
    return SafeArea(
        child: IntroductionScreen(
      pages: [
        PageViewModel(
            title: "You’re ready to begin!",
            body:
                "Every day you will be randomly assigned to choose one of your personalized goals OR choose a \"daily challenge\" designed by us. ",
            image: buildImage('assets/images/morningCity.jpeg'),
            decoration: getPageDecoration(),
            footer: ElevatedButton(
                onPressed: () async {
                  return await showInformationDialog(context);
                },
                child: Text("Tips and Tricks!"))),
      ],
      done: Text('Begin!', style: TextStyle(fontWeight: FontWeight.bold)),
      onDone: () async {
        await UDS.updateUserOnboarding(true);
        Navigator.of(context).pushReplacementNamed('/choose_task_session');
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
