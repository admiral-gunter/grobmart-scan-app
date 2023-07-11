import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/material.dart';

import '../../components/coustom_bottom_nav_bar.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/body.dart';

class MenuScreen extends StatelessWidget {
  static var routeName = '/menu';

  const MenuScreen({Key? key}) : super(key: key);

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
