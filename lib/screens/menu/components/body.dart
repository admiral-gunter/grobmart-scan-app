import 'package:flutter/material.dart';
import 'package:shop_app/screens/list_bt/list_bt_screen.dart';

import '../../../constants.dart';
import '../../purchase_order_offline/purchase_order_offline_screen.dart';

class ParentItem {
  final String title;
  final List<ChildItem> childList;
  final String route;

  ParentItem(this.title, this.childList, [this.route = '']);
}

class ChildItem {
  final String title;
  final String route;

  ChildItem(this.title, [this.route = '']);
}

List<ParentItem> parentList = [
  ParentItem(
    "Dashboard",
    [],
  ),
  ParentItem(
    "Pembelian",
    [
      ChildItem("Purchase Order", ListBtSCreen.routeName),
    ],
  ),
  ParentItem(
    "Fitur Offline",
    [
      ChildItem("Purchase Order", PurchaseOrderOfflineScreen.routeName),
      ChildItem("Pindah Gudang", PurchaseOrderOfflineScreen.routeName),
      ChildItem("Service", PurchaseOrderOfflineScreen.routeName),
    ],
  )
];

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<bool> expansionPanelStates = [];

  @override
  void initState() {
    super.initState();
    expansionPanelStates = List<bool>.filled(parentList.length, false);
  }

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
          child: ListView.builder(
            itemCount: parentList.length,
            itemBuilder: (BuildContext context, int parentIndex) {
              final parentItem = parentList[parentIndex];
              if (parentItem.childList.isEmpty) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, parentItem.route);
                  },
                  child: ListTile(
                    title: Text(parentItem.title),
                  ),
                );
              } else {
                return ExpansionTile(
                  title: Text(parentItem.title),
                  children: parentItem.childList
                      .map((childItem) => InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, childItem.route);
                            },
                            child: ListTile(
                              title: Text(childItem.title),
                            ),
                          ))
                      .toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
