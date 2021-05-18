import 'dart:js';

import 'package:flutter/widgets.dart';
import 'package:gas_gameappstore/screens/Cart/cart_screen.dart';
import 'package:gas_gameappstore/screens/home/home_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  CartScreen.routeName: (context) => CartScreen(),
};
