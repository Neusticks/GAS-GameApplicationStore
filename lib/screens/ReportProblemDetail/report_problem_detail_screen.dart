import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../size_config.dart';
import 'components/body.dart';

class ReportProblemDetailScreen extends StatelessWidget {
  final String reportId;
  static String routeName = "/reportproblemdetail";

  const ReportProblemDetailScreen({
    Key key,
    @required this.reportId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilot Request Details"),
      ),
      body: Body(
        reportId: reportId,
      ),
    );
  }
}
