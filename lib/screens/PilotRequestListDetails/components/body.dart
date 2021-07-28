import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/models/PilotRequest.dart';
import 'package:gas_gameappstore/screens/Chats/chat_screen.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:gas_gameappstore/services/database/pilot_request_database_helper.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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
                PilotRequest requestData = snapshot.data;
                String requestId = requestData.id;
                String requestOwnerId = requestData.ownerId;
                String requestUserName = requestData.userName;
                String requestGameId = requestData.gameId;
                String requestPass = requestData.gamePassword;
                String requestGameChoice = EnumToString.convertToString(requestData.gameName);
                String requestUserPhone = requestData.userPhone;
                String requestStatus = requestData.requestStatus;
                String requestAssign = requestData.assignPilot;
                return SizedBox(
                  height: getProportionScreenHeight(500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "       Pilot Request Details",
                        style: headingStyle,
                      ),
                      SizedBox(height: getProportionScreenHeight(40)),
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
                      SizedBox(height: getProportionScreenHeight(20)),
                      Text.rich(
                        TextSpan(
                            text: "Game Account: $requestGameId\n",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                            children:[
                              TextSpan(
                                text: "Game Password: $requestPass\n",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w900,
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
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15,
                                          ),
                                          children:[
                                            TextSpan(
                                              text: "Assign To: $requestAssign\n",
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15,
                                              ),
                                          children: [
                                            TextSpan(
                                              text: "Request Status: $requestStatus",
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],),
                                    ],
                                    ),
                                  ],
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      SizedBox(height: getProportionScreenHeight(30)),
                      DefaultButton(
                        text: "Chat User",
                        press: () {
                          chatUserButtonCallback(requestOwnerId, context);
                        },
                      ),
                      SizedBox(height: getProportionScreenHeight(20)),
                       DefaultButton(
                          text: "Assign Request",
                          press: () {
                            
                            final uploadFuture = assignRequestButtonCallback(requestId);
                            showDialog(context: context, builder: (context){
                              return FutureProgressDialog(
                                uploadFuture,
                                message: Text("Assigning You to this Request"),
                              );
                            },
                            );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You have been Assigned to this Request")));
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
  Future<void> assignRequestButtonCallback(requestId)  async{
    String uid = AuthentificationService().currentUser.uid;
    final requestDocSnapshot = FirebaseFirestore.instance.collection('pilotRequest').doc(requestId);
    await requestDocSnapshot.update({"assignPilot" : uid});
  }

  Future<void> chatUserButtonCallback(requestOwnerId, context) async{
    final requestDocSnapshot = await FirebaseFirestore.instance.collection('users').doc(requestOwnerId).get();
    final Map<String, dynamic> docFields = requestDocSnapshot.data();
    String avatar = docFields['userProfilePicture'].toString();
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ChatScreen(peerId: requestOwnerId, peerAvatar: avatar);
    }));
  }
}
