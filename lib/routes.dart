import 'dart:js';

import 'package:flutter/widgets.dart';
import 'package:gas_gameappstore/screens/Login/login_screen.dart';
import 'package:gas_gameappstore/screens/SignUp/signup_screen.dart';
import 'package:gas_gameappstore/screens/Welcome/welcome_screen.dart';
import 'package:gas_gameappstore/screens/Cart/cart_screen.dart';
import 'package:gas_gameappstore/screens/home/home_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  CartScreen.routeName: (context) => CartScreen(),

};
