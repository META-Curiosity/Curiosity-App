import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:curiosity_flutter/models/custom_task.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'package:curiosity_flutter/models/props.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:curiosity_flutter/helper/date_parse.dart';

class ViewTasksScreen extends StatefulWidget {
  const ViewTasksScreen({Key key}) : super(key: key);

  @override
  State<ViewTasksScreen> createState() => _ViewTasksScreen();
}

String validatorFunction(value) {
  if (value.isEmpty) {
    return "Please enter some text.";
  }
}

void updateCustomTask(UserDbService UDS, String taskId, CustomTask newTask,
    Map<String, CustomTask> oldTask, BuildContext context) async {
  await UDS.updateTask(taskId, newTask, oldTask);
  Navigator.pop(context, true);
}

class _ViewTasksScreen extends State<ViewTasksScreen> {
  final _formKey = GlobalKey<FormState>();
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  TextEditingController titleController;
  TextEditingController whenIController;
  TextEditingController iWillController;
  TextEditingController andProveItByController;

  @override
  void initState() {
    titleController = TextEditingController();
    whenIController = TextEditingController();
    iWillController = TextEditingController();
    andProveItByController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context).settings.arguments as List;
    String uuid = args[0];
    dataToBePushed arg = args[1];
    final id = arg.id;
    UserDbService UDS = UserDbService(arg.id);
    if (arg != null) {
      titleController.text = arg.user.customTasks[id].title;
      whenIController.text = arg.user.customTasks[id].moment;
      iWillController.text = arg.user.customTasks[id].method;
      andProveItByController.text = arg.user.customTasks[id].proof;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    titleController.dispose();
    whenIController.dispose();
    iWillController.dispose();
    andProveItByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as List;
    String uuid = args[0];
    dataToBePushed arg = args[1];
    final id = arg.id;
    UserDbService UDS = UserDbService(arg.user.id);
    String title = arg.user.customTasks[id].title;
    String when = arg.user.customTasks[id].moment;
    String what = arg.user.customTasks[id].method;
    String proof = arg.user.customTasks[id].proof;

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Goal',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
                const SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 42.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.grey[700],
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 18,
                        color: Colors.white,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(" When I,", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 42.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.grey[700],
                  ),
                  child: Center(
                    child: Text(
                      when,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 18,
                        color: Colors.white,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(" I will,", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 42.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.grey[700],
                  ),
                  child: Center(
                    child: Text(
                      what,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 18,
                        color: Colors.white,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(" And prove it by,", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.grey[700]),
                  child: Center(
                    child: Text(
                      proof,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 18,
                        color: Colors.white,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                    onPressed: () async {
                      Map<String, dynamic> data = {
                        'id': datetimeToString(DateTime.now()),
                        'taskTitle': what,
                        'isCustomTask': true
                      };
                      await UDS.addDailyEvalMorningEvent(data);
                      Navigator.pushReplacementNamed(
                          context, '/choose_task_session',
                          arguments: uuid);
                    },
                    icon: Icon(AntDesign.checkcircleo),
                    label: Text(
                      'Choose Task',
                      style: TextStyle(color: Color(0xffFFFFFF), fontSize: 20),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                        fixedSize: MaterialStateProperty.all(Size(1000, 48))))
              ]),
        ),
      ),
    );
  }
}
