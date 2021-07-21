import 'package:flutter/material.dart';
import 'package:gas_gameappstore/screens/PilotService/provider_models/game_details.dart';
import 'package:provider/provider.dart';
import '../../size_config.dart';
import 'components/body.dart';

class ReportProblemScreen extends StatelessWidget {
  static String routeName = "/reportproblemscreen";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: Body(
      ),
    );
  }
}