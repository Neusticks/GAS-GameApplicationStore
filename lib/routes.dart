import 'dart:js';

import 'package:flutter/widgets.dart';
import 'package:gas_gameappstore/components/forgot_password.dart';
import 'package:gas_gameappstore/screens/ChangeDisplayName/change_display_name_screen.dart';
import 'package:gas_gameappstore/screens/ChangeEmail/change_email_screen.dart';
import 'package:gas_gameappstore/screens/ChangePassword/change_password_screen.dart';
import 'package:gas_gameappstore/screens/CreateMyStore/create_mystore_screen.dart';
import 'package:gas_gameappstore/screens/FavoriteProduct/favorite_product_screen.dart';
import 'package:gas_gameappstore/screens/ForgotPassword/forgot_password_screen.dart';
import 'package:gas_gameappstore/screens/IncomingRequestProduct/incoming_request_product_screen.dart';
import 'package:gas_gameappstore/screens/Login/login_screen.dart';
import 'package:gas_gameappstore/screens/ManageAddresses/manage_addresses_screen.dart';
import 'package:gas_gameappstore/screens/Mystore/mystore_screen.dart';
import 'package:gas_gameappstore/screens/SignUp/signup_screen.dart';
import 'package:gas_gameappstore/screens/TransactionHistory/transaction_history_screen.dart';
import 'package:gas_gameappstore/screens/Welcome/welcome_screen.dart';
import 'package:gas_gameappstore/screens/Cart/cart_screen.dart';
import 'package:gas_gameappstore/screens/home/home_screen.dart';
import 'package:gas_gameappstore/screens/profile/profile_screen.dart';
import 'package:gas_gameappstore/screens/settings/profile_settings.dart';
import 'package:gas_gameappstore/screens/accountinformation/account_information.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  ProfileSettings.routeName: (context) => ProfileSettings(),
  ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
  ManageAddressesScreen.routeName: (context) => ManageAddressesScreen(),
  AccountInformationScreen.routeName: (context) => AccountInformationScreen(),
  ChangeDisplayNameScreen.routeName: (context) => ChangeDisplayNameScreen(),
  ChangeEmailScreen.routeName: (context) => ChangeEmailScreen(),
  CreateStoreFormScreen.routeName: (context) => CreateStoreFormScreen(),
  MyStoreScreen.routeName: (context) => MyStoreScreen(),
  FavoriteProductScreen.routeName: (context) => FavoriteProductScreen(),
  IncomingRequestProductScreen.routeName: (context) => IncomingRequestProductScreen(),
  TransactionHistoryScreen.routeName: (context) => TransactionHistoryScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
};
