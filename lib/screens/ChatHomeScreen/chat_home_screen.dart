import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:gas_gameappstore/models/User.dart';
import 'package:gas_gameappstore/screens/ChatHomeScreen/search_field.dart';
import 'package:gas_gameappstore/screens/Chats/chat_screen.dart';
import 'package:gas_gameappstore/screens/Chats/components/loading.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';


class ChatHomeScreen extends StatefulWidget {
  final String currentUserId;

  ChatHomeScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => ChatHomeScreenState(currentUserId: currentUserId);
}

class ChatHomeScreenState extends State<ChatHomeScreen> {
  ChatHomeScreenState({Key key, @required this.currentUserId});

  final String currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(scrollListener);
  }

  // void registerNotification() {
  //   firebaseMessaging.requestPermission();
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('onMessage: $message');
  //     if (message.notification != null) {
  //       showNotification(message.notification);
  //     }
  //     return;
  //   });
  //
  //   firebaseMessaging.getToken().then((token) {
  //     print('token: $token');
  //     FirebaseFirestore.instance.collection('users').doc(currentUserId).update({'pushToken': token});
  //   }).catchError((err) {
  //     Logger().w(err.toString());
  //   });
  // }


  void scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }


  // void onItemMenuPress(Choice choice) {
  //   if (choice.title == 'Log out') {
  //     handleSignOut();
  //   } else {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => ChatSettings()));
  //   }
  // }
  //
  // void showNotification(RemoteNotification remoteNotification) async {
  //   AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     Platform.isAndroid ? 'com.dfa.flutterchatdemo' : 'com.duytq.flutterchatdemo',
  //     'Flutter chat demo',
  //     'your channel description',
  //     playSound: true,
  //     enableVibration: true,
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   NotificationDetails platformChannelSpecifics =
  //   NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  //
  //   print(remoteNotification);
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     remoteNotification.title,
  //     remoteNotification.body,
  //     platformChannelSpecifics,
  //     payload: null,
  //   );
  // }




  // }

  // Future<Null> handleSignOut() async {
  //   this.setState(() {
  //     isLoading = true;
  //   });
  //
  //   await FirebaseAuth.instance.signOut();
  //   await googleSignIn.disconnect();
  //   await googleSignIn.signOut();
  //
  //   this.setState(() {
  //     isLoading = false;
  //   });
  //
  //   Navigator.of(context)
  //       .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat Room',
          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,

      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // SearchField(
            //   onSubmit: (value) async{
            //     final query = value.toString();
            //     if (query.length <= 0) return;
            //     List<String> searchedUserName;
            //     try{
            //       searchedUserName = await UserDatabaseHelper().searchInUser(query.toLowerCase());
            //       if (searchedUserName != null){
            //         // await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultScreen(searchQuery: query, searchResultProductsId: searchedProductsId, searchIn: "All Products",
            //         // ),
            //         // ),
            //         // );
            //       }else {
            //         throw "Couldn't Perform Search due to some unknown reason";
            //       }
            //     }catch (e){
            //       final error = e.toString();
            //       Logger().e(error);
            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$error"),
            //       ),
            //       );
            //     }
            //   },
            // ),

            // List
            Container(

              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').limit(_limit).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) => buildItem(context, snapshot.data.docs[index]),
                      itemCount: snapshot.data.docs.length,
                      controller: listScrollController,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                      ),
                    );
                  }
                },
              ),
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document != null) {
      User userChat = User.fromDocument(document);
      if (userChat.id == currentUserId) {
        return SizedBox.shrink();
      }else if(userChat.userRole == "Admin") return SizedBox.shrink();

      else {
        return Container(
          child: TextButton(
            child: Row(
              children: <Widget>[
                Material(
                  child: userChat.userProfilePicture != null
                      ? Image.network(
                    userChat.userProfilePicture,
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                            value: loadingProgress.expectedTotalBytes != null &&
                                loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: greyColor,
                      );
                    },
                  )
                      : Icon(
                    Icons.account_circle,
                    size: 50.0,
                    color: greyColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  clipBehavior: Clip.hardEdge,
                ),
                Flexible(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Nickname: ${userChat.userName}',
                            maxLines: 1,
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                        // Container(
                        //   child: Text(
                        //     'About me: ${userChat.aboutMe}',
                        //     maxLines: 1,
                        //     style: TextStyle(color: primaryColor),
                        //   ),
                        //   alignment: Alignment.centerLeft,
                        //   margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        // )
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    peerId: userChat.id,
                    peerAvatar: userChat.userProfilePicture,
                  ),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(greyColor),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }
}

// class Choice {
//   const Choice({required this.title, required this.icon});
//
//   final String title;
//   final IconData icon;
// }