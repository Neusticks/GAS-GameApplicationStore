import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/PilotRequestList/components/pilot_assign_body.dart';
import 'package:gas_gameappstore/size_config.dart';

import 'components/body.dart.dart';


class PilotRequestListScreen extends StatelessWidget {
  static String routeName = "/pilotrequestlist";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Request List"),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(child: Text("Not Assign Request"),),
                Tab(child: Text("Your Assigned Request"),),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Body(),
              AssignBody(),
            ],
          ),
        ),
      ),
    );
  }
}
