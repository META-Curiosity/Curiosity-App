import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MindfulSessionsScreen extends StatefulWidget {
  String uuid; //User id
  MindfulSessionsScreen({Key key, @required this.uuid}) : super(key: key);

  @override
  State<MindfulSessionsScreen> createState() => _MindfulSessionsScreenState();
}

class _MindfulSessionsScreenState extends State<MindfulSessionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
              child: const Text(
                'Mindful Sessions',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 150),
            SizedBox(
              width: 350,
              child: ElevatedButton.icon(
                icon: Icon(
                  MaterialCommunityIcons.food,
                  color: Colors.white,
                  size: 24.0,
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.orangeAccent, // background
                    onPrimary: Colors.white, // foreground
                    padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0)),
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, '/play_audio',
                      arguments: [widget.uuid, 0]);
                },
                label: const Text('Mindful Eating',
                    style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 350,
              child: ElevatedButton.icon(
                icon: Icon(
                  MaterialCommunityIcons.walk,
                  color: Colors.white,
                  size: 24.0,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // background
                  onPrimary: Colors.white, // foreground
                  padding: EdgeInsets.fromLTRB(80.0, 20.0, 80.0, 20.0),
                ),
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, '/play_audio',
                      arguments: [widget.uuid, 1]);
                },
                label: const Text('Mindful Walking',
                    style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 350,
              child: ElevatedButton.icon(
                icon: Icon(
                  IconData(0xe6cd, fontFamily: 'MaterialIcons'),
                  color: Colors.white,
                  size: 24.0,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue, // background
                  onPrimary: Colors.white, // foreground
                  padding: EdgeInsets.fromLTRB(80.0, 20.0, 80.0, 20.0),
                ),
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, '/play_audio',
                      arguments: [widget.uuid, 2]);
                },
                label: const Text('Mindful Washing',
                    style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
    /* Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Mindful Session Player',
            style: TextStyle(
              fontSize: 42,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.orangeAccent, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/play_audio');
            },
            child: const Text('Eating'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/play_audio');
            },
            child: const Text('Walking'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(
                context,
                '/play_audio',
                arguments: <String, String>{
                  'city': 'Berlin',
                  'country': 'Germany',
                },
              );
            },
            child: const Text('Washing'),
          ),
        ],
      ),
    ) */
  }
}
