import 'package:flutter/material.dart';
import 'package:shop_app/components/rounded_icon_btn.dart';
import 'package:shop_app/screens/scanner/scanner_screen.dart';

import '../../../constants.dart';
import '../../list_barcodes/list_barcodes_screen.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, ScannerScreen.routeName),
              child: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.scanner_rounded,
                      color: kPrimaryColor,
                    ),
                    Text(
                      'Scan Tap In',
                      style: TextStyle(color: kTextColor),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, ListBarcodesScreen.routeName),
              child: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.list_alt_outlined,
                      color: kPrimaryColor,
                    ),
                    Text(
                      'Daftar Barcode terscan',
                      style: TextStyle(color: kTextColor),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
