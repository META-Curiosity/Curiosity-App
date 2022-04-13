import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:curiosity_flutter/helper/date_parse.dart';

class EvaluationNotCompleted extends StatelessWidget {
  //Converts date into MM-DD-YY ex. 04-07-22

  String reflection = "";
  @override
  Widget build(BuildContext context) {
    String uuid = ModalRoute.of(context).settings.arguments as String;
    UserDbService UDS = UserDbService(uuid);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: height / 20, bottom: 14),
                  child: Container(
                    child: Text(
                      'No worries!',
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
                      'On the path to achieving goals, there will always be setbacks. We learn, rest, and bounce back stronger.\n\n  '
                      'Do you have any reflections about skipping today?  Please write them down below.',
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
                      style: TextStyle(color: Colors.white),
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      cursorColor: Colors.white,
                      onChanged: (val) {
                        reflection = val;
                      },
                      onTap: FocusScope.of(context).unfocus,
                      decoration: InputDecoration(
                          hintText: " Proof of work and/or reflections...",
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20),
                //   child: Text(
                //     "If your task requires you to upload a photo, please do so:",
                //     style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 20,
                //         fontWeight: FontWeight.w300),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //       left: width / 5.5, right: width / 5.5, top: 20),
                //   child: CupertinoButton(
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text(
                //             "Select Photo",
                //             style: TextStyle(
                //                 color: Colors.white,
                //                 fontSize: 18,
                //                 fontWeight: FontWeight.w400),
                //             textAlign: TextAlign.center,
                //           ),
                //         ],
                //       ),
                //       borderRadius: BorderRadius.circular(14),
                //       color: Colors.blue,
                //       onPressed: () {}),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width / 5.5,
                      top: height / 5,
                      right: width / 5.5,
                      bottom: 20),
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
                      onPressed: () async {
                        Map<String, dynamic> data = {
                          'id': datetimeToString(DateTime.now()),
                          'isSuccessful': false,
                          'imageProof': null,
                          'reflection': reflection,
                          'activityEnjoyment': null
                        };
                        print("Sending");
                        print(data);
                        await UDS.updateDailyEval(data);
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
