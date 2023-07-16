import 'package:flutter/material.dart';

import '../../components/coustom_bottom_nav_bar.dart';
import '../../enums.dart';
import './components/body.dart';

class ListBtSCreen extends StatelessWidget {
  static var routeName = '/listBt';
  const ListBtSCreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
        alignment: Alignment.centerLeft,
        color: Colors.white,
        child: TextField(
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Search',
          ),
        ),
      )),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
