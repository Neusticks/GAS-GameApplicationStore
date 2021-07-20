import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/UserDetails/components/body.dart';

import '../../size_config.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;
  static String routeName = "/userdetails";

    const UserDetailsScreen({
    Key key,
    @required this.userId,
}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
      ),
      body: Body(
        userId: userId,
      ),
    );
  }
}
