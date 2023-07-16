import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/helper/database_helper.dart';
import 'package:shop_app/routes.dart';
import 'package:shop_app/screens/menu/menu_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme(),
      initialRoute: MenuScreen.routeName,
      routes: routes,
    );
  }
}
