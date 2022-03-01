import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EvaluationNotCompleted extends StatelessWidget {
  String proof = "";
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: height / 20, bottom: 14),
                child: Container(
                  child: Text(
                    'Placeholder',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Text(
                    "placeholder, placeholder",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: height / 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(14)),
                  child: TextFormField(
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    cursorColor: Colors.white,
                    onChanged: (val) {
                      proof = val;
                    },
                    // initialValue: "Proof of work and/or reflections...",
                    decoration: InputDecoration(
                        hintText: " placeholder",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width / 5.5, right: width / 5.5, bottom: 20),
                child: CupertinoButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.blue,
                    onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
