import 'package:gas_gameappstore/screens/PilotService/components/pilot_service_form.dart';
import 'package:gas_gameappstore/screens/ReportProblem/components/report_problem_form.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionScreenWidth(screenPadding)),
        child: Column(
          children: [
            SizedBox(height: getProportionScreenHeight(10)),
            Text(
              "Report Problem",
              style: headingStyle,
            ),
            ReportProblemForm(),
          ],
        ),
      ),
    );
  }
}