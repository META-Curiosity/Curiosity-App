import 'package:flutter/material.dart';

class MindfulSessionsScreen extends StatelessWidget {
  const MindfulSessionsScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
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
