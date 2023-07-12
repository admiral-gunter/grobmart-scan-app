import 'package:flutter/material.dart';
import 'package:shop_app/screens/list_bt/list_bt_screen.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press here
        // Return true to allow the back navigation or false to block it
        // You can perform custom logic or show a dialog before allowing the navigation
        // For example, you can show an alert dialog and only allow the navigation if the user confirms
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Exit'),
              content: Text('Are you sure you want to exit?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    // Pop the current route and allow the back navigation
                    Navigator.of(context).pop(true);
                  },
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    // Stay on the current route and block the back navigation
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
        // By default, block the back navigation
        return false;
      },
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, ListBtSCreen.routeName),
                child: Container(
                  child: Column(
                    children: [
                      Icon(
                        Icons.list_alt_outlined,
                        color: kPrimaryColor,
                      ),
                      Text(
                        'List BT',
                        style: TextStyle(color: kTextColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
