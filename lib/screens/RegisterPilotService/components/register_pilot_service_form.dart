import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/components/custom_suffix_icon.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:gas_gameappstore/components/rounded_button.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:logger/logger.dart';
import '../../../constants.dart';
import 'package:intl/intl.dart';

class RegisterPilotServiceForm extends StatefulWidget {
  @override
  _RegisterPilotServiceForm createState() => _RegisterPilotServiceForm();
}

class _RegisterPilotServiceForm extends State<RegisterPilotServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _genderController = TextEditingController();
  final _DOBController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _userNameController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd");
  final formKey = new GlobalKey<FormState>();
  DateTime _selectedDate;

  @override
  void dispose() {
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    _genderController.dispose();
    _DOBController.dispose();
    _userNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionScreenWidth(screenPadding),
        ),
        child: Column(
          children: [
            buildEmailField(),
            SizedBox(height: getProportionScreenHeight(30)),
            buildUserNameField(),
            SizedBox(height: getProportionScreenHeight(30)),
            buildPasswordField(),
            SizedBox(height: getProportionScreenHeight(30)),
            buildConfirmPasswordField(),
            SizedBox(height: getProportionScreenHeight(30)),
            buildDateField(),
            SizedBox(height: getProportionScreenHeight(30)),
            buildGenderField(),
            SizedBox(height: getProportionScreenHeight(30)),
            RoundedButton(
              text: "Register Pilot",
              press: () {
                registerPilotCallback();
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
          ],
        ),
      ),
    );
  }

  Widget buildUserNameField() {
    return TextFormField(
      controller: _userNameController,
      decoration: InputDecoration(
        hintText: "Enter Pilot User Name",
        labelText: "User Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/User Icon.svg",
        ),
      ),
      validator: (value) {
        if (_userNameController.text.isEmpty) {
          return kUserNameNullError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildGenderField() {
    return TextFormField(
      controller: _genderController,
      decoration: InputDecoration(
        hintText: "Enter Pilot Gender",
        labelText: "Gender",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/User Icon.svg",
        ),
      ),
      validator: (value) {
        if (_genderController.text.isEmpty) {
          return "Please Enter Pilot Gender";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildDateField() {
    return TextFormField(
      controller: _DOBController,
      decoration: InputDecoration(
        hintText: "Enter Pilot DOB",
        labelText: "DOB",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.date_range),
      ),
      onTap: () {
        _selectDate(context);
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.orangeAccent[700],
                onPrimary: Colors.white,
                surface: Colors.orangeAccent[700],
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _DOBController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _DOBController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  Widget buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: "Enter Pilot Email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
      validator: (value) {
        if (_emailController.text.isEmpty) {
          return "Please Enter Pilot Email";
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
        hintText: "Enter Pilot Password",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (_passwordController.text.isEmpty) {
          return "Please Enter Pilot Password";
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
        hintText: "Re-enter Pilot password",
        labelText: "Confirm Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
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

  Widget buildPhoneNumberField() {
    return TextFormField(
      controller: _phoneNumberController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter Pilot Phone Number",
        labelText: "Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone),
      ),
      validator: (value) {
        if (_phoneNumberController.text.isEmpty) {
          return "Please Enter Pilot Phone Number";
        } else if (_phoneNumberController.text.length != 10) {
          return "Only 10 digits allowed";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> registerPilotCallback() async {
    if (_formKey.currentState.validate()) {
      // goto complete profile page
      final AuthentificationService authService = AuthentificationService();
      String signUpStatus = "";
      String snackbarMessage;
      try {
        final signUpFuture = authService.registerPilotUser(
          email: _emailController.text,
          userName: _userNameController.text,
          password: _passwordController.text,
          gender: _genderController.text,
          dob: _DOBController.text,
          phoneNumber: _phoneNumberController.text,
        );
        signUpFuture.then((value) => signUpStatus = value);
        signUpStatus = await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              signUpFuture,
              message: Text("Creating Pilot account"),
            );
          },
        );
        if (signUpStatus == "true") {
          snackbarMessage =
          "Registered successfully, Please verify email id";
        } else {
          snackbarMessage = signUpStatus;
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
        if (signUpStatus == "true") {
          Navigator.pop(context);
        }
      }
    }
  }
}
