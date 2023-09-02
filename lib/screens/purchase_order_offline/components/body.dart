import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../scanner/scanner_screen.dart';

class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);
  var noOG =
      'OGOF-SM-${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}}';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              child: TextFormField(
                // initialValue: initialValue,
                decoration: InputDecoration(
                  labelText: 'Penerima',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              child: TextFormField(
                // initialValue: initialValue,
                decoration: InputDecoration(
                  labelText: 'Customer',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 25,
            ),
            OutlinedButton(
              onPressed: () {
                // Add your button click logic here.
                Navigator.pushNamed(context, ScannerScreen.routeName);
              },
              child: Text('Scan SN dan Identifier',
                  style: TextStyle(color: kPrimaryColor)),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                side: BorderSide(width: 1, color: kPrimaryColor),
              ),
            ),
          ],
        ));
  }
}
