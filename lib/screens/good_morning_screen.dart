import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'package:curiosity_flutter/models/custom_task.dart';
import 'package:curiosity_flutter/services/admin_db_service.dart';

class GoodMorningScreen extends StatefulWidget {
  GoodMorningScreen({Key key}) : super(key: key);

  @override
  State<GoodMorningScreen> createState() => _GoodMorningScreenState();
}

class _GoodMorningScreenState extends State<GoodMorningScreen> {
  //UserDbService UDS = UserDbService('hashedEmail');
  UserDbService UDS;
  User user;
  AdminDbService adminDbService = new AdminDbService();

  String _id;
  @override
  void didChangeDependencies() {
    String uuid = ModalRoute.of(context).settings.arguments as String;
    setState(() {
      _id = uuid;
      UDS = UserDbService(uuid);
      // adminDbService.getUserById(uuid).then((res) {
      //   setState(() {
      //     user = res['user'];
      //   });
      // });
    });
    getUser().then((result) {
      setState(() {
        user = result;
      });
    });
    super.didChangeDependencies();
  }

  Future<User> getUser() async {
    Map<String, dynamic> userData = await UDS.getUserData();
    return userData['user'];
  }

  // void initState() {
  //   getUser().then((result) {
  //     setState(() {
  //       user = result;
  //     });
  //   });
  //   super.initState();
  // }

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
                    print(todayTask);
                    if (todayTask == 1) {
                      Navigator.of(context).pushReplacementNamed(
                          '/introduction_daily_challenge',
                          arguments: _id);
                    } else {
                      Navigator.of(context).pushReplacementNamed(
                          '/daily_custom_tasks',
                          arguments: [_id, user]);
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
