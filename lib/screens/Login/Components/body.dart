import 'package:gas_gameappstore/components/custom_suffix_icon.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/SignUp/signup_screen.dart';
import 'package:gas_gameappstore/components/have_an_account_check.dart';
import 'package:gas_gameappstore/components/rounded_button.dart';
import 'package:gas_gameappstore/screens/Home/home_screen.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'dart:async';
import 'package:logger/logger.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/signin_exceptions.dart';


class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

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
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailField(),
          SizedBox(height: getProportionScreenHeight(30)),
          buildPasswordField(),
          SizedBox(height: getProportionScreenHeight(30)),
          RoundedButton(
              text: "Sign In",
              press: () {
                signInCallback();
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
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: "Enter Your Email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
      validator: (value) {
        if (_emailController.text.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(_emailController.text)) {
          return kInvalidEmailError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter Your Password",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (_passwordController.text.isEmpty) {
          return kPassNullError;
        } else if (_passwordController.text.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> signInCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final AuthentificationService authService = AuthentificationService();
      
      String signInStatus = "";
      String snackbarMessage;
      try {
        final signInFuture = authService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        signInFuture.then((value) => signInStatus = value);
        signInStatus = await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              signInFuture,
              message: Text("Signing in to account"),
            );
          },
        );
        if (signInStatus == "true") {
          snackbarMessage = "Signed In Successfully";
        } 
        else {
          snackbarMessage = signInStatus;
        }
      } on MessagedFirebaseAuthException catch (e) {
        snackbarMessage = e.message;
      } catch (e) {
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
        if(signInStatus == "true"){
          Navigator.push(
            context, MaterialPageRoute(builder: (context){
              return HomeScreen();
          })
          );
        }
      }
    }
  }
}
