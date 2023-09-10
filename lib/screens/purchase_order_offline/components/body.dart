import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/screens/purchase_order_offline/components/dropdown_search.dart';

import '../../../constants.dart';
import '../../../helper/database_helper.dart';
import '../../scanner_offline/controller/scanner_offline_controller.dart';
import '../../scanner_offline/scanner_offline_screen.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var noOG =
      'OGOF-SM-${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}}';

  Future<List<Map<String, dynamic>>> fetchData() async {
    return await DatabaseHelper.instance.getInventoryLocations();
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScannerOfflineController ctl = Get.put(ScannerOfflineController());

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        child: ListView(
          children: <Widget>[
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData(), // Call your asynchronous function here
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final data = snapshot.data;

                  return Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Lokasi',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                          ),
                          value: ctl.credentialBasic['location'] ?? null,
                          onChanged: (newValue) {
                            ctl.updateCredentialBasic('location', newValue);
                          },
                          items: data!.map((Map<String, dynamic> item) {
                            return DropdownMenuItem<String>(
                              value: item['id'].toString(),
                              child: Text(item['text']),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  );
                }
              },
            ),
            DropdownSearchWidget(),
            SizedBox(
              height: 25,
            ),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('SN'),
                      Text(
                        '''${ctl.snIdentifier['sn'] ?? ''}  ''',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Identifier'),
                      Text(
                        '''${ctl.snIdentifier['identifier'] ?? ''} ''',
                      ),
                    ],
                  ),
                  // Text('${jsonEncode(ctl.credentialBasic)}')
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            OutlinedButton(
              onPressed: () {
                // Add your button click logic here.
                Navigator.pushNamed(context, ScannerOfflineScreen.routeName);
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
            OutlinedButton(
              onPressed: () async {
                Map<String, dynamic> res = await ctl.insertDataOffline();
                String messej = '';
                var color = Colors.green;
                messej = res['message'];
                if (!res['result']) {
                  color = Colors.red;
                }
                final snackBar = SnackBar(
                  content: Text(
                    messej,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: color,
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () {
                      // Perform an action when the user clicks the "OK" button.
                    },
                  ),
                  duration:
                      Duration(milliseconds: 2500), // Set the duration here
                );

                // Show the SnackBar
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text('Submit', style: TextStyle(color: kPrimaryColor)),
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
