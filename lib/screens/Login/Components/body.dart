import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/Login/Components/background.dart';
import 'package:gas_gameappstore/screens/SignUp/signup_screen.dart';
import 'package:gas_gameappstore/components/have_an_account_check.dart';
import 'package:gas_gameappstore/components/rounded_password_field.dart';
import 'package:gas_gameappstore/components/rounded_input_field.dart';
import 'package:gas_gameappstore/components/rounded_button.dart';

import 'package:flutter_svg/svg.dart';
import 'package:gas_gameappstore/screens/Home/home_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

// Future<FirebaseUser> signInWithGoogle(SignInViewModel model) async {
//   model.state = ViewState.Busy;
//
//   GoogleSignInAccount googleSignInAccount = await _googleSign.signIn();
//
//   GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//
//   AuthCredential credential = GoogleAuthProvider().getCredential(
//     accessToken: googleSignInAuthentication.accessToken,
//     idToken: googleSignInAuthentication.idToken,
//   );
//
//   AuthResult authResult = await _auth.signInWithCredential(credential);
//
//   _user = authResult.user;
//
//   assert(!_user.isAnonymous);
//
//   assert(await _user.getIdToken() != null);
//
//   FirebaseUser currentUser = await _auth.currentUser();
//
//   assert(_user.uid == currentUser.uid);
//
//   model.state = ViewState.Idle;
//   print("User Name: ${_user.displayName}");
//   print("User Email ${_user.email}");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
                text: "LOGIN",
                press: () {
                  signInWithGoogle();
                }),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
