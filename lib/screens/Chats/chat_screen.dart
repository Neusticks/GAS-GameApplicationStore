import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:gas_gameappstore/models/User.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';

import 'components/body.dart';

class ChatScreen extends StatelessWidget{
  final String peerId;
  final String peerAvatar;


  ChatScreen({
    Key key,
    @required this.peerId,
    @required this.peerAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userName;
    UserDatabaseHelper().getUserWithID(peerId).then((value){
      userName = value.userName;
    });
    print(userName);
    return Scaffold(

      appBar: AppBar(
        title: Text(
          'Chat',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Body(
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}