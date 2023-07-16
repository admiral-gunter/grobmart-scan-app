import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/coustom_bottom_nav_bar.dart';
import '../../controllers/list_bt_controller.dart';
import '../../enums.dart';
import './components/body.dart';

class ListBtSCreen extends StatelessWidget {
  static var routeName = '/listBt';
  ListBtSCreen({Key? key}) : super(key: key);

  final TextEditingController _textEditingController = TextEditingController();

  // void _handleEditingComplete() {
  //   String enteredText = _textEditingController.text;
  //   // Perform desired actions with enteredText
  //   print('Entered text: $enteredText');
  // }

  @override
  Widget build(BuildContext context) {
    final ListBtController ctl = Get.put(ListBtController());
    return Scaffold(
      appBar: AppBar(
          title: Container(
        alignment: Alignment.centerLeft,
        color: Colors.white,
        child: TextField(
          controller: _textEditingController,
          onEditingComplete: () {
            ctl.searchByTxt(_textEditingController.text);
          },
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
