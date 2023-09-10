import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/screens/pindah_gudang_offline/pindah_gudang_offline_screen.dart';
import 'package:shop_app/screens/universal_scannner/controller/universal_scanner_data.dart';

import '../../../constants.dart';
import '../../../helper/database_helper.dart';
import '../../universal_scannner/universal_scanner_screen.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<Map<String, dynamic>>> fetchData() async {
    return await DatabaseHelper.instance.getInventoryLocations();
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UniversalScannerData ctl = Get.put(UniversalScannerData());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
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
          SizedBox(height: 20.0),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchData(), // Call your asynchronous function here
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final data = snapshot.data;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Dari Gudang',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      ),
                      // value: ctl.credentialBasic['location'] ?? null,
                      onChanged: (newValue) {
                        // ctl.updateCredentialBasic('location', newValue);
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
                );
              }
            },
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchData(), // Call your asynchronous function here
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final data = snapshot.data;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Ke Gudang',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      ),
                      // value: ctl.credentialBasic['location'] ?? null,
                      onChanged: (newValue) {
                        // ctl.updateCredentialBasic('location', newValue);
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
                );
              }
            },
          ),
          TextFormField(
            // initialValue: initialValue,
            decoration: InputDecoration(
              labelText: 'KD Pindah Gudang',
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
          SizedBox(height: 10.0),
          Obx(() => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('SN'), Text(ctl.snIdentifier['sn'] ?? '')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Identifier'),
                      Text(ctl.snIdentifier['identifier'] ?? '')
                    ],
                  )
                ],
              )),
          SizedBox(height: 10.0),
          Container(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UniversalScannerSCreen(
                        goBack: () => Navigator.pushReplacementNamed(
                            context, PindahGudangOfflineScreen.routeName)),
                  ),
                );
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
          ),
          Container(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: Text('Submit', style: TextStyle(color: kPrimaryColor)),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                side: BorderSide(width: 1, color: kPrimaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
