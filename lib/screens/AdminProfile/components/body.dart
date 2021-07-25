import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/ChatHomeScreen/chat_home_screen.dart';
import 'package:gas_gameappstore/screens/Login/login_screen.dart';
import 'package:gas_gameappstore/screens/ManagePilotRequest/manage_pilot_screen.dart';
import 'package:gas_gameappstore/screens/ManageReport/manage_report_screen.dart';
import 'package:gas_gameappstore/screens/ManageUserAdmin/manage_user_screen.dart';
import 'package:gas_gameappstore/screens/RegisterPilotService/register_pilot_service_screen.dart';
import 'package:gas_gameappstore/screens/Settings/profile_settings.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';

import 'admin_profile_menu.dart';
import 'admin_profile_pic.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  FirebaseAuth auth = FirebaseAuth.instance;
  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          AdminProfilePic(),
          SizedBox(height: 20),
          AdminProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileSettings();
                  }))
          ),
          AdminProfileMenu(
            text: "Chats",
            icon: "assets/icons/User Icon.svg",
            press: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ChatHomeScreen(currentUserId: AuthentificationService().currentUser.uid);
                })),
          ),
          AdminProfileMenu(
            text: "Manage Users Account", 
            icon: "assets/icons/User Icon.svg",
            press: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ManageUserScreen();
                })),
          ),
          AdminProfileMenu(
              text: "Register Pilot",
              icon: "assets/icons/User Icon.svg",
              press: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                return RegisterPilotServiceScreen();
              })),
          ),
          AdminProfileMenu(
            text: "Manage Pilot Request",
            icon: "assets/icons/Bell.svg",
            press: () => Navigator.push(context, MaterialPageRoute(builder: (context){
              return ManagePilotRequestScreen();
            })),
          ),
          AdminProfileMenu(
            text: "Manage Report",
            icon: "assets/icons/Question mark.svg",
            press: () => Navigator.push(context, MaterialPageRoute(builder: (context){
              return ManageReportScreen();
            })),
          ),
          AdminProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () async{
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: _signOut,
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () async{
                        Navigator.pop(context, 'No');
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }));
  }

}
