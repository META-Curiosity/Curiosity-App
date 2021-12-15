import 'package:curiosity_flutter/models/nightly_evaluation.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'package:curiosity_flutter/models/custom_task.dart';

class FirebaseTest extends StatefulWidget {
  const FirebaseTest({Key key}) : super(key: key);

  @override
  _FirebaseTestState createState() => _FirebaseTestState();
}

class _FirebaseTestState extends State<FirebaseTest> {
  UserDbService UDS = UserDbService("hashedEmail");

  Future<User> getUser() async {
    Map<String, dynamic> userData = await UDS.getUserData();
    return userData['user'];
  }

  void initState() {
    Map<String, dynamic> data = {
      "method": null,
      "title": null,
      "moment": null,
      "proof": null
    };
    CustomTask zero = new CustomTask.fromData(data);
// To be replace by the user original tasks dictionary in the database
    getUser().then((result) {
      Map<String, CustomTask> oldTask = result.customTasks;
      UDS.updateTask('5', new CustomTask.fromData(data), oldTask);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Write data to firebase here."),
    );
  }
}
