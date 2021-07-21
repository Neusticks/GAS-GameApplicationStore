import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/models/PilotRequest.dart';
import 'package:gas_gameappstore/models/ReportedProblem.dart';
import 'package:gas_gameappstore/models/ReportedUser.dart';
import 'package:gas_gameappstore/services/database/pilot_request_database_helper.dart';
import 'package:gas_gameappstore/services/database/report_database_helper.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Body extends StatelessWidget {
  final String reportId;

  const Body({
    Key key,
    @required this.reportId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionScreenWidth(screenPadding)),
          child: FutureBuilder<ReportedProblem>(
            future: ReportDatabaseHelper().getReportProblemWithId(reportId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ReportedProblem requestData = snapshot.data;
                String reportId = requestData.id;
                String reportUserName = requestData.userName;
                String date = requestData.reportedDate;
                String reportDesc = requestData.problemDescription;
                return SizedBox(
                  height: getProportionScreenHeight(320),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Report Id: $reportId",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                            text: "Reported Date: $date\n",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text: "Report Description: $reportDesc\n",
                                style: TextStyle(
                                  color: kTextColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Submitted By: $reportUserName\n",
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                final error = snapshot.error.toString();
                Logger().e(error);
              }
              return Center(
                child: Icon(
                  Icons.error,
                  color: kTextColor,
                  size: 60,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}
