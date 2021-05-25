import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/Login/Components/background.dart';
import 'package:gas_gameappstore/screens/SignUp/signup_screen.dart';
import 'package:gas_gameappstore/components/have_an_account_check.dart';
import 'package:gas_gameappstore/components/rounded_password_field.dart';
import 'package:gas_gameappstore/components/rounded_input_field.dart';
import 'package:gas_gameappstore/components/rounded_button.dart';
import 'package:gas_gameappstore/screens/Home/home_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  

  Future loginUser(String userEmail, String userPassword) async {
    var url = "http://10.0.2.2/UsersDB/User_Login.php";
    var response = await http.post(Uri.parse(url), body: {
      "UserEmail": userEmail,
      "UserPassword": userPassword,
    });
      var loginData = json.encode(response.body);

    if (loginData == null) {
      setState(() {
        print("Login Fail");
      });
    } else {
      if (loginData == 'Success') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen();
            },
          ),
        );
      } else if (loginData == 'Admin') {
        print("blom jadi");
      }
      // setState(() {
      //   userEmail = loginData[0]['UserEmail'];
      // });
    }
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
              controller: _emailController,
              hintText: "Email",
              onChanged: (value) {
                _emailController.text = value;
              },
            ),
            RoundedPasswordField(
              controller: _passwordController,
              onChanged: (value) {
                _passwordController.text = value;
              },
            ),
            RoundedButton(
                text: "LOGIN",
                press: () {
                  loginUser(_emailController.text, _passwordController.text);
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
