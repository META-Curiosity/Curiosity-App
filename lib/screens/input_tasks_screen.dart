import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputTasksScreen extends StatelessWidget {
  const InputTasksScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          const Center(
              child: Text('New Task',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32))),
          const SizedBox(height: 30),
          Text(" When I,", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          TextField(
            decoration: InputDecoration(
              hintText: "prepare to cook dinner",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
          ),
          const SizedBox(height: 30),
          Text(" I will,", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          TextField(
            decoration: InputDecoration(
              hintText: "find a new recipe to make",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
          ),
          const SizedBox(height: 30),
          Text(" And prove it by,", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "uploading a photo of the dish and the recipe.",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              contentPadding: EdgeInsets.all(60.0),
              hintMaxLines: 2,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
              onPressed: () {}, //TODO
              icon: Icon(IconData(57424, fontFamily: 'MaterialIcons')),
              label: Text(
                'Create Task',
                style: TextStyle(color: Color(0xffFFFFFF), fontSize: 20),
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )),
                  fixedSize: MaterialStateProperty.all(Size(1000, 48))))
        ]),
      ),
    );
  }
}
