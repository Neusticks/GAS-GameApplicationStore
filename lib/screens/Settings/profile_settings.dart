import 'package:flutter/material.dart';

import 'components/body.dart';

class ProfileSettings extends StatelessWidget {
  static String routeName = "/profilesettings";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
      ),
      body: Body(),
    );
  }
}
