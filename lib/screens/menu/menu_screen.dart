import 'dart:convert';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:http/http.dart' as http;

import '../../components/coustom_bottom_nav_bar.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../helper/database_helper.dart';
import '../../shared_preferences/shared_token.dart';
import '../../size_config.dart';
import 'components/body.dart';

class MenuScreen extends StatefulWidget {
  static var routeName = '/menu';

  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Future<void> checkTokenAndNavigate() async {
    // Get the SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the token value
    String? token = prefs.getString('token');
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    // Check if the token exists
    if (token != null && currentRoute != MenuScreen.routeName) {
      // Token exists, redirect to another page
      Navigator.pushReplacementNamed(context, MenuScreen.routeName);
    } else if (token == null && currentRoute != SignInScreen.routeName) {
      // Token does not exist, stay on the current page or redirect to a login page
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    }
  }

  Future<void> initData() async {
    try {
      final token = await SharedToken.tokenGetter();
      final companyId = await SharedToken.companyGetter();

      var param = '?field=select2_gudang&tipe=1';
      var url = Uri.parse(
          '${kURL_ORIGIN}select2/get-raw/${companyId}/${token!}${param}');
      print(url);

      var response = await http.post(url);

      var res = jsonDecode(response.body);
      await DatabaseHelper.instance.insertDatainventoryLocation(res);
    } catch (e) {
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
      print('ERROR following: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    checkTokenAndNavigate();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
