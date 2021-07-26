import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:gas_gameappstore/screens/ManageReport/components/problem_report_body.dart';
import 'package:gas_gameappstore/screens/ManageReport/components/user_report_body.dart';

class ManageReportScreen extends StatefulWidget{
  @override
  _ManageReportScreenState createState() => _ManageReportScreenState();
}

class _ManageReportScreenState extends State<ManageReportScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Manage Report", style: headingStyle),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(child: Text("Problem Report")),
                Tab(child: Text("User Report")),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ProblemReportBody(),
              UserReportBody(),
            ],
          ),
        ),
      ),
    );
  }
}