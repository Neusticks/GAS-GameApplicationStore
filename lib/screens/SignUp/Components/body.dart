import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/signup_exceptions.dart';
import 'package:gas_gameappstore/screens/Login/login_screen.dart';
import 'package:gas_gameappstore/components/have_an_account_check.dart';
import 'package:gas_gameappstore/components/rounded_button.dart';
import 'package:gas_gameappstore/screens/SignUp/Components/or_divider.dart';
import 'package:gas_gameappstore/screens/SignUp/Components/social_icon.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:logger/logger.dart';
import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            buildEmailField(),
            SizedBox(height: getProportionScreenHeight(30)),
            buildPasswordField(),
            SizedBox(height: getProportionScreenHeight(30)),
            buildConfirmPasswordField(),
            SizedBox(height: getProportionScreenHeight(40)),
            RoundedButton(
              text: "SIGNUP",
              press: () {
                signUpCallback();
              },
              // press: () async {
              // try {
              //   await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
              // } on FirebaseAuthException catch (e) {
              //     if (e.code == 'weak-password') {
              //       print('The password provided is too weak.');
              //     } else if (e.code == 'email-already-in-use') {
              //       print('The account already exists for that email.');
              //     }
              // }catch (e) {
              //     print(e);
              //   }
              // }
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocialIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocialIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocialIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
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

  Widget buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Re-enter your password",
        labelText: "Confirm Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (_confirmPasswordController.text.isEmpty) {
          return kPassNullError;
        } else if (_confirmPasswordController.text !=
            _passwordController.text) {
          return kMatchPassError;
        } else if (_confirmPasswordController.text.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> signUpCallback() async {
    if (_formKey.currentState.validate()) {
      // goto complete profile page
      final AuthentificationService authService = AuthentificationService();
      bool signUpStatus = false;
      String snackbarMessage;
      try {
        final signUpFuture = authService.signUp(
          email: _emailController.text,
          password: _passwordController.text,
        );
        signUpFuture.then((value) => signUpStatus = value);
        signUpStatus = await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              signUpFuture,
              message: Text("Creating new account"),
            );
          },
        );
        if (signUpStatus == true) {
          snackbarMessage =
              "Registered successfully, Please verify your email id";
        } else {
          throw FirebaseSignUpAuthUnknownReasonFailureException();
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
        if (signUpStatus == true) {
          Navigator.pop(context);
        }
      }
    }
  }
}
