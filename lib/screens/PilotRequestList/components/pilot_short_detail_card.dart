import 'package:enum_to_string/enum_to_string.dart';
import 'package:gas_gameappstore/models/PilotRequest.dart';
import 'package:gas_gameappstore/services/database/pilot_request_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class PilotShortDetailCard extends StatelessWidget {
  final String requestId;
  final VoidCallback onPressed;
  const PilotShortDetailCard({
    Key key,
    @required this.requestId,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: FutureBuilder<PilotRequest>(
        future: PilotDatabaseHelper().getRequestWithID(requestId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final pilot = snapshot.data;
            String gameId = pilot.gameId;
            String gameName = EnumToString.convertToString(pilot.gameName);
            String assignTo = pilot.assignPilot;
            String requestStatus = pilot.requestStatus;
            return Row(
              children: [
                SizedBox(width: getProportionScreenWidth(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pilot.id,
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
                            text: 'Game Account: $gameId         ',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: '\nGame Name: $gameName',
                                style: TextStyle(
                                  color: kTextColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: '\nAssign To: $assignTo',
                                style: TextStyle(
                                  color: kTextColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                )
                              ),
                              TextSpan(
                                text: '\nRequest Status: $requestStatus',
                                style: TextStyle(
                                  color: kTextColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
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