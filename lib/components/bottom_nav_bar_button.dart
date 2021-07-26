import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gas_gameappstore/models/Store.dart';
import 'package:gas_gameappstore/screens/AdminProfile/admin_profile_screen.dart';
import 'package:gas_gameappstore/screens/CreateMyStore/create_mystore_screen.dart';
import 'package:gas_gameappstore/screens/FavoriteProduct/favorite_product_screen.dart';
import 'package:gas_gameappstore/screens/Home/home_screen.dart';
import 'package:gas_gameappstore/screens/Mystore/mystore_screen.dart';
import 'package:gas_gameappstore/screens/Profile/profile_screen.dart';
import 'package:gas_gameappstore/services/authentification/authentification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_gameappstore/services/database/store_database_helper.dart';

import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatefulWidget {
  final MenuState selectedMenu;
  final Store store;
  const CustomBottomNavBar({
    Key key,
    this.selectedMenu,
    this.store,
  }) : super(key: key);

  @override
  _CustomBottomNavBar createState() => _CustomBottomNavBar(selectedMenu);
}

class _CustomBottomNavBar extends State<CustomBottomNavBar> {
  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Store store;
  MenuState selectedMenu;

  _CustomBottomNavBar(MenuState selectedMenu){
    this.selectedMenu = selectedMenu;
  }

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/homeicon.svg",
                    color: MenuState.home ==  selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HomeScreen();
                    }))),
              IconButton(
                icon: SvgPicture.asset("assets/icons/Heart Icon.svg",
                color: MenuState.favourite == selectedMenu ? kPrimaryColor : inActiveIconColor,
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return FavoriteProductScreen();
                    }))),
              IconButton(
                icon: SvgPicture.asset("assets/icons/Shop Icon.svg",
                color: MenuState.message == selectedMenu ? kPrimaryColor : inActiveIconColor),
                onPressed: () => storeButtonCallback(context),
              ),
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/User Icon.svg",
                    color: MenuState.profile == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () => profileButtonCallback(context),
                  ),
            ],
          )),
    );
  }

  Future<void> storeButtonCallback(BuildContext context) async {
    String uid = AuthentificationService().currentUser.uid;
    final storeCollectionRef = firestore.collection('stores');
    final storeDoc = await storeCollectionRef.where(StoreDatabaseHelper.STORE_OWNER_ID_KEY, isEqualTo: uid).get();
    List storeUid = List<String>();
    for (final doc in storeDoc.docs) {
      storeUid.add(doc.id);
    }
    if (storeUid.isEmpty == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CreateStoreFormScreen();
      }));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyStoreScreen();
      }));
    }
  }

  Future<void> profileButtonCallback(BuildContext context) async{
    String uid = AuthentificationService().currentUser.uid;
    final userCollectionRef = firestore.collection('users');
    final userDoc = await userCollectionRef.doc(uid).get();
    Map<String, dynamic> docFields = userDoc.data();
    var userRole = docFields["userRole"].toString();
    if(userRole == "Customer" || userRole == "customer"){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return ProfileScreen();
      }));
    }
    else if(userRole == "Admin" || userRole == "admin"){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return AdminProfileScreen();
      }));
    }
  }
}
