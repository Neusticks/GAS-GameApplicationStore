import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/PilotRequestDetails/components/body.dart';


import '../../size_config.dart';

class RequestDetailsScreen extends StatelessWidget {
  final String requestId;
  static String routeName = "/requestdetails";

    const RequestDetailsScreen({
    Key key,
    @required this.requestId,
}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilot Request Details"),
      ),
      body: Body(
        requestId: requestId,
      ),
    );
  }
}
