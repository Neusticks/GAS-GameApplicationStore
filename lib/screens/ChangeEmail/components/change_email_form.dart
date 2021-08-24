import 'package:gas_gameappstore/components/custom_suffix_icon.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/credential_actions_exceptions.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:gas_gameappstore/screens/Login/login_screen.dart';

import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';

class ChangeEmailForm extends StatefulWidget {
  @override
  _ChangeEmailFormState createState() => _ChangeEmailFormState();
}

class _ChangeEmailFormState extends State<ChangeEmailForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    currentEmailController.dispose();
    newEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionScreenWidth(screenPadding)),
        child: Column(
          children: [
            buildCurrentEmailFormField(),
            SizedBox(height: getProportionScreenHeight(30)),
            buildNewEmailFormField(),
            SizedBox(height: getProportionScreenHeight(30)),
            buildPasswordFormField(),
            SizedBox(height: getProportionScreenHeight(40)),
            DefaultButton(
              text: "Change Email",
              press: () async{
                await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Change Email'),
                    content: const Text('Are you sure you want to change your email?\nPlease note that if you change your email, you will be log out from the application.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: _changeEmail,
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () async{
                          Navigator.pop(context, 'No');
                        },
                        child: const Text('No'),
                      ),
                    ],
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
    return form;
  }

  Future<void> _changeEmail() async{
    final updateFuture = changeEmailButtonCallback();
    showDialog(
      context: context,
      builder: (context) {
        return FutureProgressDialog(
          updateFuture,
          message: Text("Updating Email"),
        );
      },
    );
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password",
        labelText: "Enter Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (passwordController.text.isEmpty) {
          return "Password cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentEmailFormField() {
    return StreamBuilder<User>(
      stream: AuthentificationService().userChanges,
      builder: (context, snapshot) {
        String currentEmail;
        if (snapshot.hasData && snapshot.data != null)
          currentEmail = snapshot.data.email;
        final textField = TextFormField(
          controller: currentEmailController,
          decoration: InputDecoration(
            hintText: "CurrentEmail",
            labelText: "Current Email",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSuffixIcon(
              svgIcon: "assets/icons/Mail.svg",
            ),
          ),
          readOnly: true,
        );
        if (currentEmail != null) currentEmailController.text = currentEmail;
        return textField;
      },
    );
  }

  Widget buildNewEmailFormField() {
    return TextFormField(
      controller: newEmailController,
      decoration: InputDecoration(
        hintText: "Enter New Email",
        labelText: "New Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
      validator: (value) {
        if (newEmailController.text.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(newEmailController.text)) {
          return kInvalidEmailError;
        } else if (newEmailController.text == currentEmailController.text) {
          return "Email is already linked to account";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> changeEmailButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final AuthentificationService authService = AuthentificationService();
      String passwordValidation =
          await authService.verifyCurrentUserPassword(passwordController.text);
      if (passwordValidation == "true") {
        bool updationStatus = false;
        String snackbarMessage;
        try {
          updationStatus = await authService.changeEmailForCurrentUser(
              newEmail: newEmailController.text);
          if (updationStatus == true) {
            snackbarMessage =
                "Verification email sent. Please verify your new email";
            await FirebaseAuth.instance.signOut();
            return Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LoginScreen();
            }));
          } else {
            throw FirebaseCredentialActionAuthUnknownReasonFailureException(
                message:
                    "Couldn't process your request now. Please try again later");
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
        }
      }
    }
  }
}