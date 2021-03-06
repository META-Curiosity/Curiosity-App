import 'package:curiosity_flutter/models/custom_task.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
//screens
import 'screens/onboarding_screen.dart';
import 'screens/edit_custom_tasks_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/input_tasks_screen.dart';
import 'screens/central_dashboard_screen.dart';
import 'screens/mindful_sessions_screen.dart';
import 'screens/play_audio_screen.dart';
import 'screens/good_morning_screen.dart';
import 'screens/firebase_test_screen.dart';
import 'package:curiosity_flutter/models/daily_evaluation.dart';
import 'screens/mindful_sessions_screen.dart';
import 'screens/welcome_back_screen.dart';
import 'package:curiosity_flutter/helper/date_parse.dart';
import 'package:curiosity_flutter/services/meta_task_db_service.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // UserDbService UDS = UserDbService('hashedEmail');
  // User user = User();

  UserDbService UDS;
  User user;
  String _id;
  int index = 0; //index for nav bar
  bool haveMindfullness = false;
  int labId = -1;

  @override
  void didChangeDependencies() {
    List<dynamic> args =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    String uuid = args[0];
    int start = args[1];
    setState(() {
      _id = uuid;
      index = start;
      UDS = UserDbService(uuid);
    });
    //Checks if user has access to mindfulness
    UDS.getUserData().then((res) {
      user = res['user'];
      haveMindfullness = res['user'].labId % 2 == 0;
      labId = res['user'].labId;
    });
    getEverything().then((result) {
      setState(() {
        print('haveMindfulness = ' + haveMindfullness.toString());
        if (haveMindfullness == true) {
          screens = [
            WelcomeBackScreen(
              date: result[3][0],
              task: result[3][1],
              uuid: uuid,
              taskStatus: result[3][2],
              description: result[3][3],
            ),
            MindfulSessionsScreen(
                uuid: uuid), //To be replaced with meditation screen
            CentralDashboardScreen(
                dates: listOfDailyEvaluationsToMap(result[1]),
                records: result[2],
                user: result[0]),
            EditCustomTasksScreen(user: result[0]),
          ];
          items = <Widget>[
            Icon(Icons.home, size: 20, color: Colors.black),
            Icon(Entypo.leaf, size: 20, color: Colors.black),
            Icon(Icons.today, size: 20, color: Colors.black),
            Icon(Icons.list, size: 20, color: Colors.black),
          ];
        } else {
          screens = [
            WelcomeBackScreen(
                date: result[3][0],
                task: result[3][1],
                uuid: uuid,
                taskStatus: result[3][2],
                description: result[3][3]),
            CentralDashboardScreen(
                dates: listOfDailyEvaluationsToMap(result[1]),
                records: result[2],
                user: result[0]),
            EditCustomTasksScreen(user: result[0]),
          ];
          items = <Widget>[
            Icon(Icons.home, size: 20, color: Colors.black),
            Icon(Icons.today, size: 20, color: Colors.black),
            Icon(Icons.list, size: 20, color: Colors.black),
          ];
        }

        _dataRecieved = true;
        print("DONE $_dataRecieved");
      });
    });
    _pageController = PageController(initialPage: index);
    super.didChangeDependencies();
  }

  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  List<Widget> screens = [];
  List<Widget> items = [];
  Map<DateTime, List<DailyEvaluation>> _dates = {};
  bool _datesRecieved = false;
  bool _recordsRecieved = false;
  bool _dataRecieved = false;
  DateTime today = DateTime.now();
  Map<String, dynamic> _records = {};
  PageController _pageController;

  //get User object to pass into the set_custom_tasks screen
  Future<User> getUser() async {
    Map<String, dynamic> userData = await UDS.getUserData();
    return userData['user'];
  }

  //Takes the currentMonth and returns a list of daily evaluation from firestore under the user's collection.
  Future<List<DailyEvaluation>> getDates(DateTime currentMonth) async {
    String convertedTime =
        '${currentMonth.month.toString().padLeft(2, '0')}-31-${currentMonth.year.toString().substring(2, 4)}'; //MM-DD-YYYY
    Map<String, dynamic> datesObj =
        await UDS.getUserDailyEvalDatesByMonth(convertedTime);
    List<DailyEvaluation> sucessfulDates = [];
    for (DailyEvaluation dateEvals in datesObj['dailyEvalRecords']) {
      if (dateEvals.isSuccessful == true) {
        sucessfulDates.add(dateEvals);
      }
    }

    return sucessfulDates;
  }

  //Converts Datetime object into a string of form example: 'Sun, Nov 28'
  String datetimeToString1(DateTime date) {
    DateFormat formatter = DateFormat('E, MMM d');
    String formattedDate = formatter.format(date);
    return formattedDate;
  }

  //Gets today's date and task.  Returns object {String date, String task}
  Future<List<dynamic>> getToday() async {
    List<dynamic> res = List.filled(4, 0);

    String today = datetimeToString1(DateTime.now());

    String task = '';
    int taskStatus = -1; //-1 is null, 0 is skip, 1 is completed
    String description = '';
    bool isCustomTask = false;
    String difficulty;
    int taskId;
    int labId;

    //Checks if task has been skipped or completed +  get task title
    await UDS
        .getUserDailyEvalByDate(datetimeToString(DateTime.now()))
        .then((res) {
      task = res['dailyEvalRecord'].taskTitle;
      isCustomTask = res['dailyEvalRecord'].isCustomTask;

      if (isCustomTask) {
        CustomTask ct;

        for (int i = 0; i < 6; i++) {
          String customTaskId = i.toString();
          if (user.customTasks[customTaskId].method == task) {
            ct = user.customTasks[customTaskId];
            break;
          }
        }
        description =
            "When I ${ct.moment}, I will ${ct.method}, and prove it by ${ct.proof}.";
      } else {
        taskId = int.parse(res['dailyEvalRecord'].taskId);
        difficulty = res['dailyEvalRecord'].taskDifficulty;
      }

      if (res['dailyEvalRecord'].isSuccessful != null) {
        if (res['dailyEvalRecord'].isSuccessful == false) {
          taskStatus = 0;
        } else {
          taskStatus = 1;
        }
      }
    });

    //Get task description
    if (!isCustomTask) {
      MetaTaskDbServices MTDS = new MetaTaskDbServices();
      await MTDS.getTaskByDifficultyAndID(difficulty, taskId).then((res) {
        description = res['metaTask'].description;
      });
      print('DESCRIPTION: ${description}');
    }
    res[0] = today;
    res[1] = task;
    res[2] = taskStatus;
    res[3] = description;

    return res;
  }

  //Takes a String date in the form MM-DD-YY and converts it into a DateTime object.
  DateTime stringToDateTime(String date) {
    List<String> dateSplit = date.split('-');
    return DateTime.utc(int.parse(dateSplit[2]) + 2000, int.parse(dateSplit[0]),
        int.parse(dateSplit[1]));
  }

  //Takes in a List of Daily Evaluations and returns a list of extracted DateTime
  Map<DateTime, List<DailyEvaluation>> listOfDailyEvaluationsToMap(
      List<DailyEvaluation> neList) {
    Map<DateTime, List<DailyEvaluation>> res = {};
    for (DailyEvaluation ne in neList) {
      DateTime neDate = stringToDateTime(ne.id);
      if (res[neDate] == null) res[neDate] = [];
      res[neDate].add(ne);
    }
    return res;
  }

  Future<Map<String, dynamic>> getStreaksAndTotalDaysCompleted() async {
    return await UDS.getUserStreakAndTotalDaysCompleted();
  }

  Future<List<dynamic>> getEverything() async {
    List<dynamic> res = List.filled(4, 0);
    res[0] = await getUser();
    res[1] = await getDates(today);
    res[2] = await getStreaksAndTotalDaysCompleted();
    res[3] = await getToday();
    return res;
  }

  void initState() {
    print('init state');
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !_dataRecieved
        ? Loading()
        : Scaffold(
            body: SizedBox.expand(
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (i) {
                  setState(() => index = i);
                },
                children: screens,
              ),
            ),
            bottomNavigationBar: CurvedNavigationBar(
                key: navigationKey,
                color: Colors.white,
                backgroundColor: Colors.amber,
                height: 65,
                items: items,
                index: index,
                animationDuration: Duration(milliseconds: 300),
                animationCurve: Curves.easeInOut,
                onTap: (index) {
                  setState(() => this.index = index);
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }));
  }
}

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.amber,
        child:
            Center(child: SpinKitThreeBounce(color: Colors.white, size: 50.0)));
  }
}
