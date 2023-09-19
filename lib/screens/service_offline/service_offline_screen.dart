import 'package:flutter/material.dart';
import 'components/body.dart';

import '../../components/coustom_bottom_nav_bar.dart';
import '../../enums.dart';

class ServiceOfflineScreen extends StatelessWidget {
  const ServiceOfflineScreen({Key? key}) : super(key: key);
  static String routeName = "/service-offline";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
            title: Container(
          alignment: Alignment.centerLeft,
          color: Colors.white,
        )),
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
