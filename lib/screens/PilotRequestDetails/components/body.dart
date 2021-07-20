import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/models/PilotRequest.dart';
import 'package:gas_gameappstore/models/User.dart';
import 'package:gas_gameappstore/services/database/pilot_request_database_helper.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:gas_gameappstore/services/database/product_database_helper.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:gas_gameappstore/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/utils.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';



class Body extends StatelessWidget {
  final String requestId;

  const Body({
    Key key,
    @required this.requestId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionScreenWidth(screenPadding)),
          child: FutureBuilder<PilotRequest>(
            future: PilotDatabaseHelper().getRequestWithID(requestId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final requestData = snapshot.data;
                String requestId = requestData.id;
                String requestUserName = requestData.userName;
                String requestGameId = requestData.gameId;
                String requestGameChoice = requestData.gameName.toString();
                String requestUserPhone = requestData.userPhone;
                String requestStatus = requestData.requestStatus;
                return SizedBox(
                  height: getProportionScreenHeight(320),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Request Id: $requestId",
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
                            text: "Game Account: $requestGameId\n",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text: "Account Owner: $requestUserName\n",
                                style: TextStyle(
                                  color: kTextColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: "User Phone Number: $requestUserPhone\n",
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Game Choice: $requestGameChoice\n",
                                          style: TextStyle(
                                            color: kTextColor,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Request Status: $requestStatus",
                                              style: TextStyle(
                                                color: kTextColor,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      SizedBox(height: 10),
                       DefaultButton(
                          text: "Finish Request",
                          press: () {
                            
                            final uploadFuture = finishRequestButtonCallback(requestId);
                            showDialog(context: context, builder: (context){
                              return FutureProgressDialog(
                                uploadFuture,
                                message: Text("Finishing Request"),
                              );
                            },
                            );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pilot Request Have been Finished")));
                          },
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
  Future<void> finishRequestButtonCallback(requestId)  async{
    final requestDocSnapshot = FirebaseFirestore.instance.collection('pilotRequest').doc(requestId);
    await requestDocSnapshot.update({"requestStatus" : "Finished"});
    print("Pilot Request Have Been Finished");
  }
  
}
