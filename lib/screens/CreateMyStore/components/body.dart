import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gas_gameappstore/components/nothingtoshow_container.dart';
import 'package:gas_gameappstore/screens/MyProduct/my_product_screen.dart';
import 'package:gas_gameappstore/screens/MyStore/components/body.dart';
import 'package:gas_gameappstore/screens/Mystore/mystore_screen.dart';
import 'package:gas_gameappstore/services/database/store_database_helper.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';
import 'package:gas_gameappstore/size_config.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/models/Store.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import 'create_store_screen.dart';
import '../../MyStore/components/mystore_menu.dart';

class Body extends StatefulWidget {
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  // @override
  // Widget build(BuildContext context){
  //   return FutureBuilder<Store>(
  //     future: StoreDatabaseHelper().userStoreWithId,
  //     builder: (context, snapshot) {
  //       if(snapshot.hasData){
  //       }
  //       else if(snapshot.data == null){
  //         return SingleChildScrollView(
  //           physics: BouncingScrollPhysics(),
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(
  //                 horizontal: getProportionScreenWidth(screenPadding)),
  //             child: Column(
  //               children: [
  //                 SizedBox(height: SizeConfig.screenHeight * 0.04),
  //                 Text(
  //                   "Create Store",
  //                   style: headingStyle,
  //                 ),
  //                 CreateStoreForm(),
  //               ],
  //             ),
  //           ),
  //         );
  //       }
  //       else if(snapshot.connectionState == ConnectionState.waiting){
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }else if(snapshot.hasError){
  //         final error = snapshot.error;
  //         Logger().w(error.toString());
  //         return Center(
  //           child: Text(
  //             error.toString(),
  //           )
  //         );
  //       }else{
  //         return Center(
  //           child: Icon(
  //             Icons.error,
  //           )
  //         );
  //       }
  //     }
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    var userStoreId;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionScreenWidth(screenPadding)),
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(auth.currentUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    Map<String, dynamic> docFields = snapshot.data.data();
                    userStoreId = docFields["userStoreId"].toString();
                    if (userStoreId == "null") {
                      return CreateStoreForm();
                    } else {
                       Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return MyStoreScreen();
                      }));
                    }
                    // userName = docFields["userName"].toString();
                  }
                  return Center(
                    child: NothingToShowContainer(
                      iconPath: "assets/icons/network_error.svg",
                      primaryMessage: "Something went wrong",
                      secondaryMessage: "Unable to connect to Database",
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
