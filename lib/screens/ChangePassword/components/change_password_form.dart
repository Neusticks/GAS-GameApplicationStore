import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_gameappstore/components/custom_suffix_icon.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/credential_actions_exceptions.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

class ChangePasswordForm extends StatefulWidget {
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionScreenWidth(screenPadding)),
        child: Column(
          children: [
            buildCurrentPasswordFormField(),
            SizedBox(height: getProportionScreenHeight(30)),
            buildNewPasswordFormField(),
            SizedBox(height: getProportionScreenHeight(30)),
            buildConfirmNewPasswordFormField(),
            SizedBox(height: getProportionScreenHeight(40)),
            DefaultButton(
              text: "Change Password",
              press: () {
                final updateFuture = changePasswordButtonCallback();
                showDialog(
                  context: context,
                  builder: (context) {
                    return FutureProgressDialog(
                      updateFuture,
                      message: Text("Updating Password"),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmNewPasswordFormField() {
    return TextFormField(
      controller: confirmNewPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Confirm New Password",
        labelText: "Confirm New Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (confirmNewPasswordController.text != newPasswordController.text) {
          return "Not matching with Password";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentPasswordFormField() {
    return TextFormField(
      controller: currentPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter Current Password",
        labelText: "Current Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        return null;
      },
      autovalidateMode: AutovalidateMode.disabled,
    );
  }

  Widget buildNewPasswordFormField() {
    return TextFormField(
      controller: newPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter New password",
        labelText: "New Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (newPasswordController.text.isEmpty) {
          return "Password cannot be empty";
        } else if (newPasswordController.text.length < 8) {
          return "Password too short";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> changePasswordButtonCallback() async {
    String snackbarMessage;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final AuthentificationService authService = AuthentificationService();
      String currentPasswordValidation = "";
      currentPasswordValidation = await authService.verifyCurrentUserPassword(currentPasswordController.text.trim());
      // final userDocSnapshotFirst = await FirebaseFirestore.instance.collection("users").doc(authService.currentUser.uid).get();
      // if(userDocSnapshotFirst.data()["userPassword"] == currentPasswordController.text) currentPasswordValidation = true;
      if (currentPasswordValidation != "true") {
        snackbarMessage = "Current password provided is wrong";
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      } else {
        bool updationStatus = false;
        try {
          updationStatus = await authService.changePasswordForCurrentUser(
              newPassword: newPasswordController.text);
          if (updationStatus == true) {
            String uid = AuthentificationService().currentUser.uid;
            final userDocSnapshot = FirebaseFirestore.instance.collection('users').doc(uid);
            await userDocSnapshot.update({"userPassword" : newPasswordController.text});
            snackbarMessage = "Password changed successfully";
          } else {
            //throw FirebaseCredentialActionAuthUnknownReasonFailureException(message: "Failed to change password, due to some unknown reason");
            snackbarMessage = "Failed to change password";
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
