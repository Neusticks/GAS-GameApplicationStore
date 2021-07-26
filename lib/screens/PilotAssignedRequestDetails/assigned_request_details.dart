import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../size_config.dart';
import 'components/body.dart';

class AssignPilotRequestDetailsScreen extends StatelessWidget {
  final String requestId;
  static String routeName = "/pilotrequestdetails";

  const AssignPilotRequestDetailsScreen({
    Key key,
    @required this.requestId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
      ),
      body: Body(
        requestId: requestId,
      ),
    );
  }
}
