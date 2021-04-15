import 'package:flutter/material.dart';
import 'package:shopping_client/screens/group_page.dart';
import 'package:shopping_client/screens/home.dart';
import 'package:shopping_client/screens/shopping_page.dart';
import 'package:shopping_client/util/route_info.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(builder: (context) => Home());
      case RouteNames.group:
        return MaterialPageRoute(builder: (context) => GroupPage(args));
      case RouteNames.shopping:
        return MaterialPageRoute(builder: (context) => ShoppingListPage(args));
    }
  }
}
