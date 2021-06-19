import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/AccountInformation/components/account_information_menu.dart';
import 'package:gas_gameappstore/screens/AccountInformation/components/specific_information_menu.dart';
import 'package:gas_gameappstore/screens/ChangeDisplayName/change_display_name_screen.dart';
import 'package:gas_gameappstore/screens/ChangeEmail/change_email_screen.dart';

import 'package:gas_gameappstore/screens/ChangePhoneNumber/change_phone_screen.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    var userName, userDOB, userGender, userEmail, userPhoneNumber;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(height: 20),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection("users").doc(auth.currentUser.uid).snapshots(),
            builder: (context, snapshot){
              if(snapshot.hasData && snapshot.data != null){
                Map<String, dynamic> docFields = snapshot.data.data();
                userName = docFields["userName"].toString();
              }
              return AccountInformationMenu(
                text: "Nama: \n$userName",
                press: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChangeDisplayNameScreen();
                })),
              );
            }
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("users").doc(auth.currentUser.uid).snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasData && snapshot.data != null){
                  Map<String, dynamic> docFields = snapshot.data.data();
                  userDOB = docFields["userDOB"].toString();
                }
                return SpecificInformationMenu(
                  text: "Date of Birth: \n$userDOB",
                );
              }
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("users").doc(auth.currentUser.uid).snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasData && snapshot.data != null){
                  Map<String, dynamic> docFields = snapshot.data.data();
                  userGender = docFields["userGender"].toString();
                }
                return SpecificInformationMenu(
                  text: "Gender: \n$userGender",
                );
              }
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("users").doc(auth.currentUser.uid).snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasData && snapshot.data != null){
                  Map<String, dynamic> docFields = snapshot.data.data();
                  userEmail = docFields["userEmail"].toString();
                }
                return AccountInformationMenu(
                  text: "Email: \n$userEmail",
                  press: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChangeEmailScreen();
                  })),
                );
              }
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("users").doc(auth.currentUser.uid).snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasData && snapshot.data != null){
                  Map<String, dynamic> docFields = snapshot.data.data();
                  userPhoneNumber = docFields["userPhoneNumber"].toString();
                }
                return AccountInformationMenu(
                  text: "Phone Number: \n$userPhoneNumber",
                  press: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChangePhoneScreen();
                  })),
                );
              }
          ),
        ],
      ),
    );
  }
}
