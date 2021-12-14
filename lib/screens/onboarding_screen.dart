import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            color: Colors.amber,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[StartJourneyScreen()],
            )),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        backgroundColor: Colors.amber,
        height: 65,
        items: <Widget>[
          Icon(Icons.home, size: 20, color: Colors.black),
          Icon(Icons.today, size: 20, color: Colors.black),
          Icon(Icons.list, size: 20, color: Colors.black),
        ],
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          // debugPrint("Current index is $index");
        },
      ),
    );
    //   body: PageView.builder(
    //       itemCount: 3,
    //       itemBuilder: (_, i) {
    //         return Padding(
    //           padding: const EdgeInsets.all(40),
    //           child: Column(
    //             children: [
    //               SvgPicture.asset(
    //                 "assets/delivery.svg",
    //                 height: 300,
    //               ),
    //               Text(
    //                 "Curiosity",
    //                 style: TextStyle(
    //                   fontSize: 35,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 28,
    //               ),
    //               Text(
    //                 "Lorem ipsum",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                     fontSize: 18,
    //                     color: CupertinoColors.darkBackgroundGray),
    //               )
    //             ],
    //           ),
    //         );
    //       }),
    // );
  }
}

class StartJourneyScreen extends StatelessWidget {
  const StartJourneyScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
      child: Column(
        children: <Widget>[
          const Text(
            'Start your journey',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            "Begin by setting your custom tasks.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 84),
          SvgPicture.asset('assets/images/edit.svg',
              semanticsLabel: 'Pencil editing a book', height: 200),
          const SizedBox(height: 100),
          SizedBox(
            width: 275,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF4B81EF),
              ),
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/set_custom_tasks');
              },
              child: const Text("Set Custom Task"),
            ),
          )
        ],
      ),
    ));
  }
}
