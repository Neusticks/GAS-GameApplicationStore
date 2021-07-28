import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_gameappstore/components/custom_suffix_icon.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:gas_gameappstore/screens/PilotProfile/profile_screen.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailField(),
          SizedBox(height: getProportionScreenHeight(30)),
          RoundedButton(
              text: "Forgot Password",
              press: () {
                forgotPasswordCallback();
              }),
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

  Future<void> forgotPasswordCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final AuthentificationService authService = AuthentificationService();

      String resetEmailStatus = "";
      String snackbarMessage;
      try {
        final resetEmailFuture = authService.resetPasswordForEmail(_emailController.text.trim());
        resetEmailFuture.then((value) => resetEmailStatus = value);
        resetEmailStatus = await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              resetEmailFuture,
              message: Text("Sending Password Reset Email"),
            );
          },
        );
        if (resetEmailStatus == "true") {
          snackbarMessage = "Password Reset Email has been sent!";
        }
        else {
          snackbarMessage = resetEmailStatus;
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
        if(resetEmailStatus == "true"){
          Navigator.pop(context);
        }
      }
    }
  }
}
