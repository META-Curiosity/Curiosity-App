import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';
import 'package:flutter/cupertino.dart';

class ActivitySurvey extends StatefulWidget {
  const ActivitySurvey({Key key}) : super(key: key);

  @override
  _ActivitySurveyState createState() => _ActivitySurveyState();
}

class _ActivitySurveyState extends State<ActivitySurvey> {
  @override
  Widget build(BuildContext context) {
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
                    onResult: (SurveyResult result) {
                      for (var stepResult in result.results) {
                        for (var questionResult in stepResult.results) {
                          print(questionResult.valueIdentifier);
                        }
                      }
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacementNamed('/nightly_evaluation_yes');
                    },
                    task: task,
                    showProgress: true,
                    localizations: {
                      'cancel': 'Cancel',
                      'next': 'Next',
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
      InstructionStep(
        title: 'Great Job On Completing Your Task!',
        text: 'Get ready for some quick curious questions!',
        buttonText: 'Let\'s go!',
      ),
      QuestionStep(
        title: 'Activty Enjoyment',
        text: 'How much did you enjoy today’s activity?',
        isOptional: false,
        answerFormat: SingleChoiceAnswerFormat(
          textChoices: [
            TextChoice(text: 'Much more than expected', value: '5'),
            TextChoice(text: 'More than expected', value: '4'),
            TextChoice(text: 'About as much as expected', value: '3'),
            TextChoice(text: 'Less than expected', value: '2'),
            TextChoice(text: 'Much less than expected', value: '1'),
          ],
        ),
      ),
      // QuestionStep(
      //   title: 'Great Job!',
      //   text:
      //       'Do you have any reflections about what you think enabled you to be sucessful today?',
      //   answerFormat: TextAnswerFormat(
      //     maxLines: 5,
      //   ),
      // ),
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
