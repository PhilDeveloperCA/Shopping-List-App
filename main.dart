import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_client/auth_provider.dart';
import 'package:shopping_client/util/route_generator.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      builder: (context, child) => MaterialApp(
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
