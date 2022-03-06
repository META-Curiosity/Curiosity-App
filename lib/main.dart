import 'package:curiosity_flutter/const/notification_payload.dart';
import 'package:curiosity_flutter/navigation.dart';
import 'package:curiosity_flutter/services/log_service.dart';
import 'package:curiosity_flutter/services/notification_service.dart';
import 'package:curiosity_flutter/services/user_db_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
//screens
import 'screens/onboarding_screen.dart';
import 'screens/set_custom_tasks_screen.dart';
import 'screens/input_tasks_screen.dart';
import 'screens/central_dashboard_screen.dart';
import 'screens/mindful_sessions_screen.dart';
import 'screens/play_audio_screen.dart';
import 'screens/good_morning_screen.dart';
import 'screens/firebase_test_screen.dart';
import 'screens/consent_screen.dart';
import 'screens/study_id_screen.dart';
import 'screens/choose_mindfulness_session_screen.dart';
import 'screens/choose_task_session.dart';
import 'screens/introduction_screen.dart';
import 'package:curiosity_flutter/navigation.dart';
import 'screens/introduction_daily_challenge_screen.dart';
import 'screens/activity_survey_screen.dart';
//firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:curiosity_flutter/provider/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
// Messaging
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// Encryption
import 'package:crypto/crypto.dart';
import 'dart:convert';

const String ANDROID_CHANNEL_ID = 'high_importance_channel';
const String ANDROID_CHANNEL_NAME = 'High Importance Channel';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    ANDROID_CHANNEL_ID, ANDROID_CHANNEL_NAME,
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// When the user clicks on the notification when the app is in the background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // [TODO]: Mechanism to handle push notification when the application is in the background
  print('A bg message just showed up: ${message.messageId}');
}

// Initializing the application when first launched
void main() async {
  // Ensuring all widgets are initialized - mandatory
  WidgetsFlutterBinding.ensureInitialized();

  // Setting up connection with firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Setting message handler function when the application is in the background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Setting up what options for application if it is open in the foreground
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  // Creating initial settings for local notification
  var initializationSettingsAndroid =
      AndroidInitializationSettings('codex_logo');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  // Flutter initializing default settings
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      // Determine what to do with the notification once selected
      onSelectNotification: (String payload) async {
    if (payload != null) {
      if (payload == NotificationPayload.MindfulnessSession.toString()) {
        print('redirected to mindfulness screen');
        // [TODO]: redirect the user to slide 32
      } else if (payload == NotificationPayload.DailyActivitySetup.toString()) {
        print('redirected to daily activity setup screen');
        // [TODO]: redirect the user to slide 19
      } else if (payload ==
          NotificationPayload.DailyActivityCompletion.toString()) {
        print('redirected to daily activity completion screen');
        // [TODO]: redirect the user to slide 26
      }
    }
  });

  runApp(MyApp());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  _AppState createState() => _AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Scaffold(
              body: Container(
                child: MyHomePage(),
              ),
            ),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/good_morning': (context) => Scaffold(
              appBar: AppBar(
                leading: BackButton(),
                backgroundColor: Color(0xFFF6C344),
                centerTitle: true,
              ),
              body: Container(
                child: GoodMorningScreen(),
              ),
            ),
        '/onboarding': (context) => Scaffold(
              body: Container(
                child: OnboardingScreen(),
              ),
            ),
        '/set_custom_tasks': (context) => Scaffold(
              appBar: AppBar(
                leading: BackButton(),
                backgroundColor: Color(0xFFF6C344),
                centerTitle: true,
              ),
              body: Container(
                child: SetCustomTasksScreen(),
              ),
            ),
        '/input_tasks': (context) => Scaffold(
              appBar: AppBar(
                //centerTitle: true,
                leading: BackButton(),
                //title: Text('New Task'),
                backgroundColor: Color(0xFFF6C344),
              ),
              resizeToAvoidBottomInset: true,
              body: Container(
                child: InputTasksScreen(),
              ),
            ),
        '/central_dashboard': (context) => Scaffold(
              // appBar: AppBar(
              //   //centerTitle: true,
              //   leading: BackButton(),
              //   //title: Text('New Task'),
              //   backgroundColor: Color(0xFFF6C344),
              // ),
              resizeToAvoidBottomInset: true,
              body: Container(
                child: CentralDashboardScreen(),
              ),
            ),
        '/mindful_sessions': (context) => Scaffold(
              appBar: AppBar(
                //centerTitle: true,
                leading: BackButton(),
                //title: Text('New Task'),
                backgroundColor: Color(0xFFF6C344),
              ),
              resizeToAvoidBottomInset: true,
              body: Container(
                child: MindfulSessionsScreen(),
              ),
            ),
        '/play_audio': (context) => Scaffold(
              // appBar: AppBar(
              //   //centerTitle: true,
              //   leading: BackButton(),
              //   //title: Text('New Task'),
              //   backgroundColor: Color(0xFFF6C344),
              // ),
              resizeToAvoidBottomInset: true,
              body: Container(
                child: AudioPlayer(),
              ),
            ),
        '/firebase_test': (context) => Scaffold(
              appBar: AppBar(
                //centerTitle: true,
                leading: BackButton(),
                //title: Text('New Task'),
                backgroundColor: Color(0xFFF6C344),
              ),
              resizeToAvoidBottomInset: true,
              body: Container(
                child: FirebaseTest(),
              ),
            ),
        '/navigation': (context) => Scaffold(
              resizeToAvoidBottomInset: true,
              body: Container(
                child: Navigation(),
              ),
            ),
        '/consent': (context) => Scaffold(
              resizeToAvoidBottomInset: true,
              body: Container(
                child: Consent(),
              ),
            ),
        '/study_id': (context) => Scaffold(
              resizeToAvoidBottomInset: true,
              body: Container(
                child: StudyId(),
              ),
            ),
        '/choose_mindfulness_session': (context) => Scaffold(
              resizeToAvoidBottomInset: true,
              body: Container(
                child: ChooseMindfulnessSession(),
              ),
            ),
        '/choose_task_session': (context) => Scaffold(
              resizeToAvoidBottomInset: true,
              body: Container(
                child: ChooseTaskSession(),
              ),
            ),
        '/introduction': (context) => Scaffold(
              resizeToAvoidBottomInset: true,
              body: Container(
                child: Introduction(),
              ),
            ),
        '/introduction_daily_challenge': (context) => Scaffold(
              resizeToAvoidBottomInset: true,
              body: Container(
                child: IntroductionDailyChallenge(),
              ),
            ),
        '/activity_survey': (context) => Scaffold(
              resizeToAvoidBottomInset: true,
              body: Container(
                child: ActivitySurvey(),
              ),
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _pageState = 0;
  var backgroundColor = Colors.white;
  var headingColor = Color(0xFF3a82f7);

  double loginYOffset = 0;
  double windowWidth = 0;
  double windowHeight = 0;

  UserDbService userDbService;
  LogService log = new LogService();

  Future<void> initializeFirebaseMessaging() async {
    // Requesting users permission for notification
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    log.infoString('User granted permission: ${settings.authorizationStatus}');

    // Initializing push notification message for users
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log.infoString('Message received - $message');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher'),
            ));
      }
    });

    // Initializing screens to show when the user received a message with opened application
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (android != null && notification != null) {
        print('inside the dialog');
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
      }
    });
  }

  Future<void> initialize() async {
    await initializeFirebaseMessaging();
    // Change page once user is logged in
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user == null) {
        log.infoString('User is currently signed out!', 0);
      } else {
        var currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          String hashedEmail =
              sha256.convert(utf8.encode(currentUser.email)).toString();
          userDbService = UserDbService(hashedEmail);

          // Verifying if the user has registered before - if they have then
          // the application does not sign the user up
          Map<String, dynamic> isUserRegistered =
              await userDbService.getUserData();
          if (isUserRegistered['error'] != null) {
            // [TODO]: Handle the case where the database encounters an error
            //  when checking the user existence
            log.errorObj({'error': isUserRegistered['error']});
          }
          if (isUserRegistered['user'] == null) {
            // user has not registered yet -> registering the user
            await userDbService.registerUserId();
            log.successString('user has registered successfully', 0);
          } else if (isUserRegistered['user'] != null) {
            // Registered user logging back in again
            log.successString('user logged in successfully', 0);
          }
          // After user successfully register then proceed to ask them for
          // their study id
          Navigator.pushReplacementNamed(
            context,
            '/study_id',
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;
    switch (_pageState) {
      case 0:
        backgroundColor = Color(0xFFfcba3e);
        headingColor = Colors.white;
        loginYOffset = windowHeight;
        break;
      case 1:
        backgroundColor = Color(0xFFfcba3e);
        headingColor = Colors.white;
        loginYOffset = 270;
        break;
    }
    return Stack(
      children: <Widget>[
        AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: 1000),
          color: backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _pageState = 0;
                  });
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: Text(
                        "Mindful Curiosity",
                        style: TextStyle(color: headingColor, fontSize: 28),
                      ),
                    ),
                    // Lottie.asset('assets/cat.json')
                  ],
                ),
              ),
              Lottie.asset('assets/cat.json'),
              Container(
                child: Center(
                  child: Text(""),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    signInWithGoogle();
                  },
                  child: Container(
                    margin: EdgeInsets.all(50),
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xFF3a82f7),
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: Text(
                        "Sign in with Google",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _pageState = 0;
              debugPrint("HI");
            });
          },
          child: AnimatedContainer(
            padding: EdgeInsets.all(20),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform: Matrix4.translationValues(0, loginYOffset, 1),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Column(
              children: <Widget>[
                // Lottie.asset('assets/cat.json'),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Enter Your User ID",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                  child: Text(
                    "This is the code you were given at orientation. Letters are case sensitive.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                InputWithIcon(
                  icon: Icons.vpn_key,
                  hint: "Enter User ID...",
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    print('HI');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudyId()),
                    );
                    // final snackbar = SnackBar(content: Text("HI"));
                    // ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                  child: Column(children: <Widget>[
                    PrimaryButton(btnText: "Login"),
                  ]),
                  // PrimaryButton(btnText: "Login"),
                ),
                // PrimaryButton(btnText: "Login"),
                // OutlineBtn(btnText: "Create an Account")

                Lottie.asset('assets/cat.json')
              ],
            ),
          ),
        )
      ],
    );
  }
}

class InputWithIcon extends StatefulWidget {
  final IconData icon;
  final String hint;
  InputWithIcon({this.icon, this.hint});

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFBC7C7C7), width: 2),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        children: <Widget>[
          Container(
              width: 60,
              child: Icon(
                widget.icon,
                size: 20,
                color: Color(0xFFBB9B9B9),
              )),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  border: InputBorder.none,
                  hintText: widget.hint),
            ),
          )
        ],
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final String btnText;
  PrimaryButton({this.btnText});

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFF3a82f7), borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class OutlineBtn extends StatefulWidget {
  final String btnText;
  OutlineBtn({this.btnText});

  @override
  _OutlineBtnState createState() => _OutlineBtnState();
}

class _OutlineBtnState extends State<OutlineBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF3a82f7), width: 2),
          borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(color: Color(0xFF3a82f7), fontSize: 16),
        ),
      ),
    );
  }
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}
