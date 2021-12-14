import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:curiosity_flutter/models/custom_task.dart';
import 'package:curiosity_flutter/models/custom_task.dart';

class InputTasksScreen extends StatefulWidget {
  const InputTasksScreen({Key key}) : super(key: key);

  @override
  State<InputTasksScreen> createState() => _InputTasksScreenState();
}

String validatorFunction(value) {
  if (value.isEmpty) {
    return "Please enter some text.";
  }
}

class _InputTasksScreenState extends State<InputTasksScreen> {
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
    final arg = ModalRoute.of(context).settings.arguments as CustomTask;
    if (arg != null) {
      titleController.text = arg.title;
      whenIController.text = arg.moment;
      iWillController.text = arg.method;
      andProveItByController.text = arg.proof;
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
    final routeData = ModalRoute.of(context).settings.arguments as CustomTask;

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('New Task',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
                const SizedBox(height: 30),
                TextFormField(
                  controller: titleController,
                  validator: validatorFunction,
                  textAlign: TextAlign.center,
                  autofocus: (routeData != null),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    counterText: "",
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
                const SizedBox(height: 30),
                Text(" When I,", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: whenIController,
                  validator: validatorFunction,
                  decoration: InputDecoration(
                    hintText: "prepare to cook dinner",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
                const SizedBox(height: 30),
                Text(" I will,", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: iWillController,
                  validator: validatorFunction,
                  decoration: InputDecoration(
                    hintText: "find a new recipe to make",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
                const SizedBox(height: 30),
                Text(" And prove it by,", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: andProveItByController,
                  validator: validatorFunction,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "uploading a photo of the dish and the recipe.",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    contentPadding: EdgeInsets.all(30.0),
                    hintMaxLines: 2,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                    onPressed: () {
                      _formKey.currentState.validate()
                          ?
                          // final res = {
                          //   'title': titleController.text,
                          //   'one': whenIController.text,
                          //   'two': iWillController.text,
                          //   'three': andProveItByController.text
                          // };
                          //print('popped');
                          Navigator.pop(context, <String, String>{
                              'title': titleController.text,
                              'one': whenIController.text,
                              'two': iWillController.text,
                              'three': andProveItByController.text
                            })
                          : print('not valid');
                    },
                    icon: Icon(IconData(57424, fontFamily: 'MaterialIcons')),
                    label: Text(
                      'Create Task',
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
