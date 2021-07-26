
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/components/nothingtoshow_container.dart';
import 'package:gas_gameappstore/components/user_short_detail_card.dart';
import 'package:gas_gameappstore/models/User.dart';
import 'package:gas_gameappstore/screens/UserDetails/user_details_screen.dart';
import 'package:gas_gameappstore/services/data_streams/user_stream.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget{
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body>{
  final UsersStream userStream = UsersStream();
  List users;

  @override
  void initState() {
    super.initState();
    userStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    userStream.dispose();
  }

  Future<void> refreshPage() {
    userStream.reload();
    return Future<void>.value();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text("User List", style: headingStyle),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.75,
                    child: Center(
                      child: buildUsersList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildUsersList() {
    return StreamBuilder<List<String>>(
      stream: userStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> userId = snapshot.data;

          return Column(
            children: [
              SizedBox(height: getProportionScreenHeight(20)),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  physics: BouncingScrollPhysics(),
                  itemCount: userId.length,
                  itemBuilder: (context, index) {
                    if (index >= userId.length) {
                      return SizedBox(height: getProportionScreenHeight(80));
                    }
                    return buildUserCard(
                      context,  userId[index], index);
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        return Center(
          child: NothingToShowContainer(
            iconPath: "assets/icons/network_error.svg",
            primaryMessage: "Something went wrong",
            secondaryMessage: "Unable to connect to Database",
          ),
        );
      },
    );
  }

  Widget buildUsers(String userId, int index) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 10,
        top: 10,
        right: 10,
      ),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: FutureBuilder<User>(
        future: UserDatabaseHelper().getUserWithID(userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: UserShortDetailCard(
                    userId: user.id,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailsScreen(userId: userId,),),);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            Logger().w(error.toString());
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          } else {
            return Center(
              child: Icon(
                Icons.error,
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildUserCard(
      BuildContext context, String userId, int index) {
    return Container(
      key: Key(userId),
      // direction: DismissDirection.startToEnd,
      // dismissThresholds: {
      //   DismissDirection.startToEnd: 0.65,
      // },
      // background: buildUserBackground(),
      child: buildUsers(userId, index),
      // confirmDismiss: (direction) async {
      //   if (direction == DismissDirection.startToEnd) {
      //     final confirmation = await showConfirmationDialog(
      //       context,
      //       "Remove Product from Cart?",
      //     );
      //     if (confirmation) {
      //       if (direction == DismissDirection.startToEnd) {
      //         bool result = false;
      //         String snackbarMessage;
      //         try {
      //           result = await UserDatabaseHelper()
      //               .removeProductFromCart(userId);
      //           if (result == true) {
      //             snackbarMessage = "Product removed from cart successfully";
      //             await refreshPage();
      //           } else {
      //             throw "Coulnd't remove product from cart due to unknown reason";
      //           }
      //         } on FirebaseException catch (e) {
      //           Logger().w("Firebase Exception: $e");
      //           snackbarMessage = "Something went wrong";
      //         } catch (e) {
      //           Logger().w("Unknown Exception: $e");
      //           snackbarMessage = "Something went wrong";
      //         } finally {
      //           Logger().i(snackbarMessage);
      //           ScaffoldMessenger.of(context).showSnackBar(
      //             SnackBar(
      //               content: Text(snackbarMessage),
      //             ),
      //           );
      //         }

      //         return result;
      //       }
      //     }
      //   }
      //   return false;
      // },
      // onDismissed: (direction) {},
    );
  }

  // Widget buildUserBackground() {
  //   return Container(
  //     padding: EdgeInsets.only(left: 20),
  //     decoration: BoxDecoration(
  //       color: Colors.red,
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         Icon(
  //           Icons.delete,
  //           color: Colors.white,
  //         ),
  //         SizedBox(width: 4),
  //         Text(
  //           "Delete",
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 15,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // Widget buildUserList(){
  //   return StreamBuilder(
  //     stream: FirebaseFirestore.instance.collection('users').snapshots(),
  //     builder: (context, snapshot){
  //       if (snapshot.hasData){
  //         return ListView.builder(
  //         itemCount: snapshot.data.docs.length,
  //         itemBuilder: (context, index){
  //           DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
  //           return Row(
  //             children: <Widget>[
  //                 Expanded(
  //                 flex: 8,
  //                 child: Text(documentSnapshot["userEmail"]),
  //                 ),
  //               SizedBox(width: 12),
  //               Expanded(
  //                 flex: 1,
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(
  //                     horizontal: 12,
  //                     vertical: 2,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color: kTextColor.withOpacity(0.05),
  //                     borderRadius: BorderRadius.circular(15),
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       DefaultButton(
  //                         text: "Unban",
  //                         press: (){},
  //                       ),
  //                       SizedBox(height: 8),
  //                       DefaultButton(
  //                         text: "Ban",
  //                         press: (){},
  //                       ),
  //                       SizedBox(height: 8),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           );
  //         }
  //           // children: [
  //           //   SizedBox(height: getProportionScreenHeight(20)),
  //           //   Expanded(
  //           //     child: ListView.builder(
  //           //       padding: EdgeInsets.symmetric(vertical: 16),
  //           //       physics: BouncingScrollPhysics(),
  //           //       itemCount: userListId.length,
  //           //       itemBuilder: (context, index) {
  //           //       if (index >= userListId.length) {
  //           //           return SizedBox(height: getProportionScreenHeight(80));
  //           //         }
  //           //         return buildUser(snapshot.data);
  //           //       },
  //           //     ),
  //           //   ),
  //           // ],
  //         );
  //       } else if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       } else if (snapshot.hasError) {
  //         final error = snapshot.error;
  //         Logger().w(error.toString());
  //       }
  //       return Center(
  //         child: NothingToShowContainer(
  //           iconPath: "assets/icons/network_error.svg",
  //           primaryMessage: "Something went wrong",
  //           secondaryMessage: "Unable to connect to Database",
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget buildUser(List<String> usersId) {
  //   return Container(
  //     padding: EdgeInsets.only(
  //       bottom: 4,
  //       top: 4,
  //       right: 4,
  //     ),
  //     margin: EdgeInsets.symmetric(vertical: 4),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: kTextColor.withOpacity(0.15)),
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: StreamBuilder(
  //       stream: FirebaseFirestore.instance.collection('users').snapshots(),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           return ListView(
  //             children: snapshot.data.docs.map<Widget>((document){
  //               return FollowFollowerContainer(
  //                 user: User.fromMap(document.data(), document.id),
  //               );
  //             },
  //             // mainAxisSize: MainAxisSize.max,
  //             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             // children: <Widget>[
  //             //   Expanded(
  //             //     flex: 8,
  //             //     child: UserShortDetailCard(
  //             //       userId: user.id,
  //             //     ),
  //             //   ),
  //             //   SizedBox(width: 12),
  //             //   Expanded(
  //             //     flex: 1,
  //             //     child: Container(
  //             //       padding: EdgeInsets.symmetric(
  //             //         horizontal: 12,
  //             //         vertical: 2,
  //             //       ),
  //             //       decoration: BoxDecoration(
  //             //         color: kTextColor.withOpacity(0.05),
  //             //         borderRadius: BorderRadius.circular(15),
  //             //       ),
  //             //       child: Row(
  //             //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             //         children: [
  //             //           DefaultButton(
  //             //             text: "Unban",
  //             //             press: (){},
  //             //           ),
  //             //           SizedBox(height: 8),
  //             //           DefaultButton(
  //             //             text: "Ban",
  //             //             press: (){},
  //             //           ),
  //             //           SizedBox(height: 8),
  //             //         ],
  //             //       ),
  //             //     ),
  //             //   ),
  //             // ],
  //           );
  //         } else if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         } else if (snapshot.hasError) {
  //           final error = snapshot.error;
  //           Logger().w(error.toString());
  //           return Center(
  //             child: Text(
  //               error.toString(),
  //             ),
  //           );
  //         } else {
  //           return Center(
  //             child: Icon(
  //               Icons.error,
  //             ),
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }
}