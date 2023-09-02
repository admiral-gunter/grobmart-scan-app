import 'package:flutter/material.dart';

import '../../components/coustom_bottom_nav_bar.dart';
import '../../enums.dart';
import 'components/body.dart';

class PurchaseOrderOfflineScreen extends StatelessWidget {
  static var routeName = '/purchaseOrderOffline';

  PurchaseOrderOfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container();
    return Scaffold(
      appBar: AppBar(
          title: Container(
        alignment: Alignment.centerLeft,
        color: Colors.white,
      )),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
