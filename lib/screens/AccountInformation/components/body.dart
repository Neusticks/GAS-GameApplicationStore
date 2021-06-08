import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/AccountInformation/components/account_information_menu.dart';
import 'package:gas_gameappstore/screens/AccountInformation/components/specific_information_menu.dart';
import 'package:gas_gameappstore/screens/ChangeDisplayName/change_display_name_screen.dart';
import 'package:gas_gameappstore/screens/ChangeEmail/change_email_screen.dart';

import 'package:gas_gameappstore/screens/ChangePhoneNumber/change_phone_screen.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';

import 'package:gas_gameappstore/screens/ChangePassword/change_password_screen.dart';
import 'package:gas_gameappstore/screens/ChangePhoneNumber/change_phone_screen.dart';
import 'package:gas_gameappstore/screens/ManageAddresses/manage_addresses_screen.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var userName, userDOB, userGender, userEmail, userPhoneNumber;

  @override
  Widget build(BuildContext context) {
    String uid = AuthentificationService().currentUser.uid;
    FirebaseFirestore.instance.collection("users").doc(uid).snapshots().listen((event) {
      userName = event.get("userName").toString();
      userEmail = event.get("userEmail").toString();
      userPhoneNumber = event.get("userPhoneNumber").toString();
    });
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(height: 20),
          AccountInformationMenu(
            text: "Nama: \n${userName}",
            press: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChangeDisplayNameScreen();
            })),
          ),
          SpecificInformationMenu(
            text: "Tanggal Lahir: \ntanggallahir",
          ),
          SpecificInformationMenu(
            text: "Jenis Kelamin: \njeniskelamin saya",
          ),
          AccountInformationMenu(
            text: "Email: \n${userEmail}",
            press: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChangeEmailScreen();
            })),
          ),
          AccountInformationMenu(
            text: "Phone Number: \n${userPhoneNumber}",
            press: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChangePhoneScreen();
            })),
          ),
        ],
      ),
    );
  }
}
