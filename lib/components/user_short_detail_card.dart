import 'package:gas_gameappstore/models/User.dart';
import 'package:gas_gameappstore/services/database/product_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';
import 'package:logger/logger.dart';
import 'package:indonesia/indonesia.dart';

import '../constants.dart';
import '../size_config.dart';

class UserShortDetailCard extends StatelessWidget {
  final String userId;
  final VoidCallback onPressed;
  const UserShortDetailCard({
    Key key,
    @required this.userId,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: FutureBuilder<User>(
        future: UserDatabaseHelper().getUserWithID(userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            String userName = user.userName;
            String banStatus = user.userIsBan.toString();
            return Row(
              children: [
                // SizedBox(
                //   width: getProportionScreenWidth(88),
                //   child: AspectRatio(
                //     aspectRatio: 0.88,
                //     child: Padding(
                //       padding: EdgeInsets.all(10),
                //       child: snapshot.data.userProfilePicture.length > 0
                //           ? Image.network(
                //         user.userProfilePicture[0],
                //         fit: BoxFit.contain,
                //       )
                //           : Text("No Image"),
                //     ),
                //   ),
                // ),
                SizedBox(width: getProportionScreenWidth(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.id,
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
                            text: 'User Name: $userName         ',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: 'Ban Status: $banStatus',
                                style: TextStyle(
                                  color: kTextColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
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