import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/constants.dart';
import 'package:gas_gameappstore/screens/ChangeDisplayName/change_display_name_screen.dart';
import 'package:gas_gameappstore/screens/ChangeStoreAddress/change_store_address_screen.dart';
import 'package:gas_gameappstore/screens/ChangeStoreDescription/change_store_desc_screen.dart';
import 'package:gas_gameappstore/screens/ChangeStoreName/change_store_name.dart';

import 'package:gas_gameappstore/screens/StoreInformation/components/store_information_menu.dart';
import 'package:gas_gameappstore/services/database/store_database_helper.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {

  @override
  Widget build(BuildContext context) {
    var storeName, storeAddress, storeDesc;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text("Store Account", style: headingStyle),
          SizedBox(height: 20),
          StreamBuilder<QueryDocumentSnapshot>(
            stream: StoreDatabaseHelper().currentUserStoreDataStream,
            builder: (context, snapshot){
              if(snapshot.hasData && snapshot.data != null){
                Map<String, dynamic> docFields = snapshot.data.data();
                storeName = docFields["storeName"].toString();
              }
              return StoreInformationMenu(
                text: "Store Name: \n$storeName",
                press: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChangeStoreNameScreen();
                })),
              );
            }
          ),
          StreamBuilder<QueryDocumentSnapshot>(
            stream: StoreDatabaseHelper().currentUserStoreDataStream,
            builder: (context, snapshot){
              if(snapshot.hasData && snapshot.data != null){
                Map<String, dynamic> docFields = snapshot.data.data();
                storeAddress = docFields["storeAddress"].toString();
              }
              return StoreInformationMenu(
                text: "Store Address: \n$storeAddress",
                press: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ChangeStoreAddressScreen();
                })),
              );
            }
          ),
          StreamBuilder<QueryDocumentSnapshot>(
            stream: StoreDatabaseHelper().currentUserStoreDataStream,
            builder: (context, snapshot){
              if(snapshot.hasData && snapshot.data != null){
                Map<String, dynamic> docFields = snapshot.data.data();
                storeDesc = docFields["storeDescription"].toString();
              }
              return StoreInformationMenu(
                text: "Store Description: \n$storeDesc",
                press: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ChangeStoreDescScreen();
                })),
              );
            }
          ),
        ],
      ),
    );
  }
}
