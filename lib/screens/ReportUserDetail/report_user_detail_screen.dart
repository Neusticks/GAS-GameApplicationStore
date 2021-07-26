import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../size_config.dart';
import 'components/body.dart';

class ReportUserDetailScreen extends StatelessWidget {
  final String reportId;
  static String routeName = "/reportuserdetail";

  const ReportUserDetailScreen({
    Key key,
    @required this.reportId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        // title: Text("Report Detail"),
      ),
      body: Body(
        reportId: reportId,
      ),
    );
  }
}
