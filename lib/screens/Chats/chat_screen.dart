import 'package:flutter/material.dart';
import 'package:gas_gameappstore/constants.dart';

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
  Widget build(BuildContext context){
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