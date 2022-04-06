import 'dart:developer';

import 'package:curiosity_flutter/screens/nightly_evaluation_no.dart';
import 'package:curiosity_flutter/screens/nightly_evaluation_yes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NightlyEvaluation extends StatefulWidget {
  @override
  State<NightlyEvaluation> createState() => _NightlyEvaluationState();
}

class _NightlyEvaluationState extends State<NightlyEvaluation> {
  bool yes = false;

  bool no = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.black,
        elevation: 0,
        title: Container(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "Nightly Evaluation",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: height / 4),
            child: Container(
              child: Text(
                "Were you successful in completing your daily activity?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            height: 120,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      yes = !yes;
                      no = false;
                    });
                  },
                  child: Container(
                    width: yes ? 120 : 100,
                    height: yes ? 120 : 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: yes ? 10 : 0,
                            color: yes ? Colors.blue : Colors.transparent),
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.green),
                    child: Center(
                      child: Text(
                        "YES",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      yes = false;
                      no = !no;
                    });
                  },
                  child: Container(
                    width: no ? 120 : 100,
                    height: no ? 120 : 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: no ? 10 : 0,
                            color: no ? Colors.blue : Colors.transparent),
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.red),
                    child: Center(
                      child: Text(
                        "NO",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: width / 5.5, right: width / 5.5, top: height / 3.5),
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
                onPressed: () {
                  if (yes) {
                    log("yes");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EvaluationCompletedPage()),
                    );
                  } else if (no) {
                    log("no");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EvaluationNotCompleted()));
                  } else {
                    log("Nothing selected");
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.grey[800],
                            title: Text(
                              "Nothing selected!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    child: Text(
                                      "You need to make a selection before continuing to next page.",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: CupertinoButton(
                                      color: Colors.blue,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  )
                                ]),
                          );
                        });
                  }
                }),
          )
        ],
      ),
    );
  }
}
