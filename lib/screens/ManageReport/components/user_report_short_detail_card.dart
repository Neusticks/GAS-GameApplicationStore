import 'package:enum_to_string/enum_to_string.dart';
import 'package:gas_gameappstore/models/PilotRequest.dart';
import 'package:gas_gameappstore/models/ReportedProblem.dart';
import 'package:gas_gameappstore/models/ReportedUser.dart';
import 'package:gas_gameappstore/services/database/pilot_request_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/services/database/report_database_helper.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class UserReportShortDetail extends StatelessWidget {
  final String reportId;
  final VoidCallback onPressed;
  const UserReportShortDetail({
    Key key,
    @required this.reportId,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: FutureBuilder<ReportedUser>(
        future: ReportDatabaseHelper().getUserReportWithId(reportId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final report = snapshot.data;
            String date = report.reportedDate;
            String userName = report.userName;
            return Row(
              children: [
                SizedBox(width: getProportionScreenWidth(10)),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.id,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: kTextColor,
                            ),
                            maxLines: 2,
                          ),
                          SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                                text: 'Reported Date: $date         ',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: '\nSubmitted By: $userName',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                ]),
                          ),
                        ])),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString();
            Logger().e(errorMessage);
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
    );
  }
}