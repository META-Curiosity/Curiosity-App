import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'package:curiosity_flutter/models/nightly_evaluation.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  UserDbService UDS = UserDbService('hashedEmail');
  User user = User();
  int index = 1; //index for nav bar
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  List<Widget> screens = [];
  Map<DateTime, List<NightlyEvaluation>> _dates = {};
  bool _datesRecieved = false;
  bool _recordsRecieved = false;
  bool _dataRecieved = false;
  final PageController _pageController = PageController();
  DateTime today = DateTime.now();
  Map<String, dynamic> _records = {};

  //get User object to pass into the set_custom_tasks screen
  Future<User> getUser() async {
    Map<String, dynamic> userData = await UDS.getUserData();
    return userData['user'];
  }

  //Takes the currentMonth and returns a list of nightly evaluation from firestore under the user's collection.
  Future<List<NightlyEvaluation>> getDates(DateTime currentMonth) async {
    String convertedTime =
        '${currentMonth.month.toString().padLeft(2, '0')}-31-${currentMonth.year.toString().substring(2, 4)}'; //MM-DD-YYYY
    Map<String, dynamic> datesObj =
        await UDS.getUserNightlyEvalDatesByMonth(convertedTime);

    return datesObj['nightEvalRecords'];
  }

  //Takes a String date in the form MM-DD-YY and converts it into a DateTime object.
  DateTime stringToDateTime(String date) {
    List<String> dateSplit = date.split('-');
    return DateTime.utc(int.parse(dateSplit[2]) + 2000, int.parse(dateSplit[0]),
        int.parse(dateSplit[1]));
  }

  //Takes in a List of Nightly Evaluations and returns a list of extracted DateTime
  Map<DateTime, List<NightlyEvaluation>> listOfNightlyEvaluationsToMap(
      List<NightlyEvaluation> neList) {
    Map<DateTime, List<NightlyEvaluation>> res = {};
    for (NightlyEvaluation ne in neList) {
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
    List<dynamic> res = List.filled(3, 0);
    res[0] = await getUser();
    res[1] = await getDates(today);
    res[2] = await getStreaksAndTotalDaysCompleted();
    return res;
  }

  void initState() {
    // //getUser
    // getUser().then((result) {
    //   setState(() {
    //     user = result;
    //     screens = [
    //       OnboardingScreen(), //To be replaced with meditation screen
    //       CentralDashboardScreen(dates: _dates, records: _records),
    //       EditCustomTasksScreen(user: user),
    //     ];
    //   });
    // });
    //
    // //get list of nightly evaluations
    // getDates(today).then((result) {
    //   setState(() {
    //     _dates = listOfNightlyEvaluationsToMap(result); //Set list of dates
    //     _datesRecieved = true; //Set Data Recieved to true
    //   });
    // });
    //
    // //get Streaks and Total Days Completed
    // getStreaksAndTotalDaysCompleted().then((result) {
    //   setState(() {
    //     _records = result;
    //     _recordsRecieved = true;
    //   });
    // });
    print('init state');
    getEverything().then((result) {
      setState(() {
        screens = [
          OnboardingScreen(), //To be replaced with meditation screen
          CentralDashboardScreen(
              dates: listOfNightlyEvaluationsToMap(result[1]),
              records: result[2]),
          EditCustomTasksScreen(user: result[0]),
        ];
        _dataRecieved = true;
        print("DONE $_dataRecieved");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home, size: 20, color: Colors.black),
      Icon(Icons.today, size: 20, color: Colors.black),
      Icon(Icons.list, size: 20, color: Colors.black),
    ];
    return !_dataRecieved
        ? Loading()
        : Scaffold(
            body: screens[index],
            bottomNavigationBar: CurvedNavigationBar(
                key: navigationKey,
                color: Colors.white,
                backgroundColor: Colors.amber,
                height: 65,
                items: items,
                index: index,
                animationDuration: Duration(milliseconds: 300),
                animationCurve: Curves.easeInOut,
                onTap: (index) => setState(() => this.index = index)));
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
