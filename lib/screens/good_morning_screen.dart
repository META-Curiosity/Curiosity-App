import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoodMorningScreen extends StatelessWidget {
  GoodMorningScreen({Key key}) : super(key: key);

  UserDbService UDS = UserDbService('hashedEmail');

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
                  onPressed: () async {
                    int todayTask;
                    await UDS
                        .getTypeOfTaskToday()
                        .then((Map<String, dynamic> res) {
                      todayTask = res['userTypeOfTaskToday'];
                    });
                    if (todayTask == 1) {
                      Navigator.of(context)
                          .pushReplacementNamed('/choose_task_session');
                    } else {
                      Navigator.of(context).pushReplacementNamed(
                          '/introduction_daily_challenge');
                    }
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
