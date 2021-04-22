import 'package:curiosity_flutter/screens/start_journey_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
          color: Colors.amber,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[StartJourneyScreen()],
          )),
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
