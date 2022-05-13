import 'package:curiosity_flutter/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:intl/intl.dart';
import 'package:curiosity_flutter/helper/date_parse.dart';

class MindfulCompletion extends StatefulWidget {
  const MindfulCompletion({Key key}) : super(key: key);

  @override
  _MindfulCompletionState createState() => _MindfulCompletionState();
}

class _MindfulCompletionState extends State<MindfulCompletion> {
  //UserDbService UDS = UserDbService('hashedEmail');

  UserDbService UDS;
  NotificationService ns;
  String _id;

  @override
  void didChangeDependencies() {
    String uuid = ModalRoute.of(context).settings.arguments as String;
    setState(() {
      _id = uuid;
      UDS = UserDbService(uuid);
      ns = NotificationService();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //Converts Datetime object into a string of form example: '01-02-22'

    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Align(
            alignment: Alignment.center,
            child: FutureBuilder<Task>(
              future: getSampleTask(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data != null) {
                  final task = snapshot.data;
                  return SurveyKit(
                    onResult: (SurveyResult result) async {
                      bool answer = false;
                      for (var stepResult in result.results) {
                        for (var questionResult in stepResult.results) {
                          print(questionResult.valueIdentifier);
                          if (questionResult.valueIdentifier == '1') {
                            answer = true;
                          }
                        }
                      }

                      Navigator.of(context, rootNavigator: true).pop(context);
                      Map<String, dynamic> data = {
                        'hasCompleted': answer,
                        'id': datetimeToString(DateTime.now())
                      };
                      await UDS.addMindfulnessSessionCompletion(data);
                      await ns.cancelMindfulSessionNotification();

                    },
                    task: task,
                    showProgress: true,
                    localizations: {
                      'cancel': 'Cancel',
                      'next': 'Submit',
                    },
                    themeData: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.fromSwatch(
                        primarySwatch: Colors.cyan,
                      ).copyWith(
                        onPrimary: Colors.white,
                      ),
                      primaryColor: Colors.cyan,
                      backgroundColor: Colors.white,
                      appBarTheme: const AppBarTheme(
                        color: Colors.white,
                        iconTheme: IconThemeData(
                          color: Colors.cyan,
                        ),
                        titleTextStyle: TextStyle(
                          color: Colors.cyan,
                        ),
                      ),
                      iconTheme: const IconThemeData(
                        color: Colors.cyan,
                      ),
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: Colors.cyan,
                        selectionColor: Colors.cyan,
                        selectionHandleColor: Colors.cyan,
                      ),
                      cupertinoOverrideTheme: CupertinoThemeData(
                        primaryColor: Colors.cyan,
                      ),
                      outlinedButtonTheme: OutlinedButtonThemeData(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                            Size(150.0, 60.0),
                          ),
                          side: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> state) {
                              if (state.contains(MaterialState.disabled)) {
                                return BorderSide(
                                  color: Colors.grey,
                                );
                              }
                              return BorderSide(
                                color: Colors.cyan,
                              );
                            },
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          textStyle: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> state) {
                              if (state.contains(MaterialState.disabled)) {
                                return Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.copyWith(
                                      color: Colors.grey,
                                    );
                              }
                              return Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                    color: Colors.cyan,
                                  );
                            },
                          ),
                        ),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                            Theme.of(context).textTheme.button?.copyWith(
                                  color: Colors.cyan,
                                ),
                          ),
                        ),
                      ),
                      textTheme: TextTheme(
                        headline2: TextStyle(
                          fontSize: 28.0,
                          color: Colors.black,
                        ),
                        headline5: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black,
                        ),
                        bodyText2: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                        subtitle1: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    surveyProgressbarConfiguration: SurveyProgressConfiguration(
                      backgroundColor: Colors.white,
                    ),
                  );
                }
                return CircularProgressIndicator.adaptive();
              },
            ),
          ),
        ),
      ),
    );
  }
}

Future<Task> getSampleTask() {
  var task = NavigableTask(
    id: TaskIdentifier(),
    steps: [
      QuestionStep(
        title: 'Mindfulness session completion',
        text: 'Did you complete the mindfulness session?',
        isOptional: false,
        answerFormat: SingleChoiceAnswerFormat(
          textChoices: [
            TextChoice(text: 'Yes', value: '1'),
            TextChoice(text: 'No', value: '0'),
          ],
        ),
      ),
      // CompletionStep(
      //   // stepIdentifier: StepIdentifier(id: '321'),
      //   text: 'Thanks for taking the survey, keep up the good habits!',
      //   title: 'Done!',
      //   buttonText: 'Submit survey',
      // ),
    ],
  );
  // task.addNavigationRule(
  //   forTriggerStepIdentifier: task.steps[6].stepIdentifier,
  //   navigationRule: ConditionalNavigationRule(
  //     resultToStepIdentifierMapper: (input) {
  //       switch (input) {
  //         case "Yes":
  //           return task.steps[0].stepIdentifier;
  //         case "No":
  //           return task.steps[7].stepIdentifier;
  //         default:
  //           return null;
  //       }
  //     },
  //   ),
  // );
  return Future.value(task);
}
