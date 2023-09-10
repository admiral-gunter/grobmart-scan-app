import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/service_offline/service_offline_screen.dart';
import 'package:shop_app/screens/universal_scannner/universal_scanner_screen.dart';

import '../../../constants.dart';
import '../../../shared_preferences/shared_token.dart';
import '../../universal_scannner/controller/universal_scanner_data.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<Map<String, dynamic>>> fetchJenisService() async {
    // Simulate an asynchronous data fetching operation (e.g., an HTTP request).
    await Future.delayed(Duration(seconds: 2));

    // Your JSON data.
    String jsonData = '''
    [
      {
        "value": "",
        "text": "Pilih Service"
      },
      {
        "value": "in_stock",
        "text": "Stock Sendiri"
      },
      {
        "value": "customer_retail",
        "text": "Customer Retail"
      },
      {
        "value": "customer_grosir",
        "text": "Customer Grosir"
      },
      {
        "value": "titip_service",
        "text": "Titip Service"
      }
    ]
  ''';

    // Parse the JSON data into a list of maps.
// Parse the JSON data into a list of maps.
    List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(json.decode(jsonData));

    return data;
  }

  Future<List<Map<String, dynamic>>> fetchCustomerRetail() async {
    final token = await SharedToken.tokenGetter();
    final companyId = await SharedToken.companyGetter();
    final apiUrl = '${kURL_ORIGIN}select2/get-raw-cs/${companyId}/${token}';

    try {
      String jsonData = '''
    [
      {
        "id": "9999999",
        "text": "DUMMY"
      },
      {
        "id": "9999999",
        "text": "Dumy"
      },
      {
        "id": "9999999",
        "text": "Dumy"
      },
      {
        "id": "9999999",
        "text": "Dummy"
      },
      {
        "id": "9999999",
        "text": "DUmyyy"
      }
    ]
  ''';

      // Parse the JSON data into a list of maps.
// Parse the JSON data into a list of maps.
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(jsonData));

      return data;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final UniversalScannerData ctl = Get.put(UniversalScannerData());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchJenisService(), // Call your asynchronous function here
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
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      ),
                      value: data![0]['value'] ?? null,
                      onChanged: (newValue) {
                        // ctl.updateCredentialBasic('location', newValue);
                      },
                      items: data.map((Map<String, dynamic> item) {
                        return DropdownMenuItem<String>(
                          value: item['value'].toString(),
                          child: Text(item['text'].toString()),
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
            decoration: InputDecoration(
              labelText: 'Costumer Retail',
              labelStyle: TextStyle(
                color: Colors.black87,
                fontSize: 17,
              ),
            ),
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
            ),
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please enter some text';
            //   }
            //   return null;
            // },
          ),
          SizedBox(
            height: 10,
          ),
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
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UniversalScannerSCreen(
                            goBack: () => Navigator.pushReplacementNamed(
                                context, ServiceOfflineScreen.routeName))));
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
