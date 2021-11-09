import 'package:curiosity_flutter/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'models/custom_task.dart';
import 'onboarding_page.dart';
import 'screens/set_custom_tasks_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/input_tasks_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
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
      initialRoute: '/set_custom_tasks',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Scaffold(
              body: Container(
                child: MyHomePage(),
              ),
            ),
        // When navigating to the "/second" route, build the SecondScreen widget.
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
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pageState = 0;
  var backgroundColor = Colors.white;
  var headingColor = Color(0xFF3a82f7);

  double loginYOffset = 0;
  double windowWidth = 0;
  double windowHeight = 0;

  FireStoreService db;
  List docs = [];
  dynamic data = Null;

  // [TODO]: authenticate the users and use hash id to initialize the database
  initialize() {
    db = FireStoreService();
    // replace with user hash email
    db.initialize('STUB');
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
        backgroundColor = Colors.white;
        headingColor = Color(0xFF3a82f7);
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
              // Lottie.asset('assets/cat.json'),
              Container(
                child: Center(
                  child: Text(""),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_pageState != 0) {
                        _pageState = 0;
                      } else {
                        _pageState = 1;
                      }
                    });
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
                        "Get Started",
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
                      MaterialPageRoute(builder: (context) => OnboardingPage()),
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
