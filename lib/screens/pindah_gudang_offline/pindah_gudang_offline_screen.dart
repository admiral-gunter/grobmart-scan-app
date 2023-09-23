import 'package:flutter/material.dart';

import '../../components/coustom_bottom_nav_bar.dart';
import '../../enums.dart';
import 'components/body.dart';

class PindahGudangOfflineScreen extends StatelessWidget {
  PindahGudangOfflineScreen({Key? key, required this.tipe}) : super(key: key);
  static String routeName = '/pindah-gudang-offline';
  final String tipe;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
            title: Container(
          alignment: Alignment.centerLeft,
          color: Colors.white,
        )),
      ),
      body: Body(tipe: tipe),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
