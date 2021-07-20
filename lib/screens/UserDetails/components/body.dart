import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gas_gameappstore/components/default_button.dart';
import 'package:gas_gameappstore/models/User.dart';
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
  final String userId;

  const Body({
    Key key,
    @required this.userId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionScreenWidth(screenPadding)),
          child: FutureBuilder<User>(
            future: UserDatabaseHelper().getUserWithID(userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data;
                String userId = userData.id;
                String userName = userData.userName;
                String userEmail = userData.userEmail;
                String banStatus = userData.userIsBan.toString();
                return SizedBox(
                  height: getProportionScreenHeight(320),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "User Id: $userId",
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
                            text: "User Name: $userName\n",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text: "User Email: $userEmail\n",
                                style: TextStyle(
                                  color: kTextColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Ban Status: $banStatus",
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
                      SizedBox(height: 10),
                       DefaultButton(
                          text: "Ban",
                          press: () {
                            
                            final uploadFuture = banAccountButtonCallback(userId);
                            showDialog(context: context, builder: (context){
                              return FutureProgressDialog(
                                uploadFuture,
                                message: Text("Banning Account"),
                              );
                            },
                            );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account Have Been Banned")));
                          },
                        ),
                        SizedBox(height: 10),
                        DefaultButton(
                          text: "Unban",
                          press: (){
                            final uploadFuture = unbanAccountButtonCallback(userId);
                            showDialog(context: context, builder: (context){
                              return FutureProgressDialog(
                                uploadFuture,
                                message: Text("Unbanning Account"),
                              );
                            },
                            );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account Have Been Unbanned")));
                          },
                        ),
                        SizedBox(height: 20),
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
  Future<void> banAccountButtonCallback(userId)  async{
    String uid = userId;
    final userDocSnapshot = FirebaseFirestore.instance.collection('users').doc(uid);
    await userDocSnapshot.update({"userIsBan" : true});
    print("Account Have Been Banned");
  }
  
  Future<void> unbanAccountButtonCallback(userId) async{
    String uid = userId;
    final userDocSnapshot = FirebaseFirestore.instance.collection('users').doc(uid);
    await userDocSnapshot.update({"userIsBan" : false});
    print("Account Have Been Unbanned");
  }
}
