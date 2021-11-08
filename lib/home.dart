import 'package:curiosity_flutter/provider/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggedIn = false;
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _isLoggedIn
            ? Column(
          children: [
            Image.network(_userObj.photoUrl),
            Text(_userObj.displayName),
            Text(_userObj.email),
            TextButton(
                onPressed: () {
                  _googleSignIn.signOut().then((value) {
                    setState(() {
                      _isLoggedIn = false;
                    });
                  }).catchError((e) {});
                },
                child: Text("Logout"))
          ],
        )
            : Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Sign up with Google'),
            onPressed: () async {
              await signInWithGoogle();
            },
            // onPressed: () {
            //   _googleSignIn.signIn().then((userData) {
            //     setState(() {
            //       _isLoggedIn = true;
            //       _userObj = userData;
            //     });
            //   }).catchError((e) {
            //     print(e);
            //   });
            // },
          ),
        ),
      ),
    );
  }
}