import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/models/Users/services.dart';
import 'package:gas_gameappstore/screens/SignUp/Components/background.dart';
import 'package:gas_gameappstore/screens/Login/login_screen.dart';
import 'package:gas_gameappstore/components/have_an_account_check.dart';
import 'package:gas_gameappstore/components/rounded_button.dart';
import 'package:gas_gameappstore/components/rounded_input_field.dart';
import 'package:gas_gameappstore/components/rounded_password_field.dart';
import 'package:gas_gameappstore/screens/SignUp/Components/or_divider.dart';
import 'package:gas_gameappstore/screens/SignUp/Components/social_icon.dart';

class Body extends StatelessWidget {
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  _createTable() {
    Services.createTable();
  }

  _addUser() {
    if (_emailController.text.isEmpty ||
        _userNameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      print("Empty Fields");
      return;
    }
    Services.addUser(_emailController.text, _userNameController.text,
            _passwordController.text)
        .then((result) {
      if ('Success' == result) {
        print("Success Register Account");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
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
            RoundedInputField(
              controller: _emailController,
              hintText: "Email",
              onChanged: (value) {
                _emailController.text = value;
              },
            ),
            RoundedInputField(
              controller: _userNameController,
              hintText: "User Name",
              onChanged: (value) {
                _userNameController.text = value;
              },
            ),
            RoundedPasswordField(
              controller: _passwordController,
              onChanged: (value) {
                _passwordController.text = value;
              },
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {
                _addUser();
              },
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
}
