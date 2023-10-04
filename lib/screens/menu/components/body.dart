import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shop_app/screens/grosir_tap_out/grosir_tap_out.dart';
import 'package:shop_app/screens/purchase_order/purchase_order_screen.dart';
import 'package:shop_app/screens/retail_tap_out/retail_tap_out_screen.dart';
import 'package:shop_app/screens/service_offline/controller/service_offline_controller.dart';
import 'package:shop_app/screens/service_offline/service_offline_screen.dart';

import '../../../constants.dart';
import '../../pindah_gudang_offline/pindah_gudang_offline_screen.dart';
import '../../purchase_order_offline/purchase_order_offline_screen.dart';
import '../../universal_scannner/controller/universal_scanner_data.dart';

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
      ChildItem("Terima Barang (PO)", ListBtSCreen.routeName),
    ],
  ),
  ParentItem(
    "Fitur Offline",
    [
      ChildItem("Terima Barang (PO)", PurchaseOrderOfflineScreen.routeName),
      ChildItem("Out Grosir", GrosirTapOut.routeName),
      ChildItem("Out Retail", RetailTapOutScreen.routeName),
      ChildItem("Pindah Gudang (Terima)", '/pindah-gudang-offline-terima'),
      ChildItem("Pindah Gudang (Keluar)", '/pindah-gudang-offline-keluar'),
      ChildItem("Service", ServiceOfflineScreen.routeName),
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
    final UniversalScannerData ctl = Get.put(UniversalScannerData());
    final ServiceOfflineController ctr = Get.put(ServiceOfflineController());

    // ctl.snIdentifier.clear();
    // ctl.itemScanned.clear();
    return WillPopScope(
      onWillPop: () async {
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
                    SystemNavigator.pop();
                  },
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
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
                              ctr.basicCredential.clear();
                              ctl.snIdentifier.clear();
                              ctl.itemScanned.clear();
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
