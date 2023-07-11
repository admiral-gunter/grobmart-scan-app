import 'package:flutter/material.dart';
import 'package:shop_app/helper/database_helper.dart';
import 'package:shop_app/routes.dart';
import 'package:shop_app/screens/menu/menu_screen.dart';
import 'package:shop_app/theme.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme(),
      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      initialRoute: MenuScreen.routeName,
      routes: routes,
    );
  }
}
