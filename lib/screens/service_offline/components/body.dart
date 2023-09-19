import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/service_offline/controller/service_offline_controller.dart';
import 'package:shop_app/screens/service_offline/service_offline_screen.dart';
import 'package:shop_app/screens/universal_scannner/universal_scanner_screen.dart';

import '../../../constants.dart';
import '../../../helper/database_helper.dart';
import '../../../shared_preferences/shared_token.dart';
import '../../universal_scannner/controller/universal_scanner_data.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<Map<String, dynamic>>> fetchJenisService() async {
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

  void showSnackBar(
      BuildContext context, String message, int durationInSeconds) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(
          seconds: durationInSeconds), // Convert seconds to milliseconds
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<Map<String, dynamic>> dataDropdown = [];
  void initState() {
    // d.itemScanned.clear();
    // ctl.itemScanned.clear();
    fetchJenisService().then((value) {
      setState(() {
        dataDropdown.addAll(value);
      });
    });
    super.initState();
  }

  Map<String, dynamic> basicCredential = {};

  @override
  Widget build(BuildContext context) {
    final ServiceOfflineController ctr = Get.put(ServiceOfflineController());
    final UniversalScannerData ctl = Get.put(UniversalScannerData());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
            value: ctr.basicCredential['tipe'],
            onChanged: (newValue) {
              ctr.changeBasicCredential('tipe', newValue);
              setState(() {
                basicCredential['tipe'] = newValue;
              });
              // ctl.updateCredentialBasic('location', newValue);
            },
            items: dataDropdown!.map((Map<String, dynamic> item) {
              return DropdownMenuItem<String>(
                value: item['value'].toString(),
                child: Text(item['text'].toString()),
              );
            }).toList(),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            initialValue: ctr.basicCredential['customer_nama'],
            onChanged: (value) {
              ctr.changeBasicCredential('customer_nama', value);
            },
            decoration: InputDecoration(
              labelText: 'Nama Customer ',
              labelStyle: TextStyle(
                color: Colors.black87,
                fontSize: 17,
              ),
            ),
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: ctr.basicCredential['customer_notelp'],
            onChanged: (value) {
              ctr.changeBasicCredential('customer_notelp', value);
            },
            decoration: InputDecoration(
              labelText: 'No HP/Telp',
              labelStyle: TextStyle(
                color: Colors.black87,
                fontSize: 17,
              ),
            ),
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(
            () => SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
                child: ListView.builder(
                  itemCount: ctl.itemScanned.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = ctl.itemScanned[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0), // Adjust as needed
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('SN'),
                              Text(
                                '${data['sn'] ?? ''}  ',
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Identifier'),
                              Text(
                                '${data['identifier'] ?? ''} ',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
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
                            goBackRouteName: ServiceOfflineScreen.routeName)));
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
              onPressed: () async {
                for (var i = 0; i < ctl.itemScanned.length; i++) {
                  final scan = ctl.itemScanned[i];
                  ctr.basicCredential['sn'] = scan['sn'];
                  ctr.basicCredential['identifier'] = scan['identifier'];
                  final ms = await DatabaseHelper.instance
                      .insertServiceOffline(ctr.basicCredential);
                  print(ms);
                }
                final i = await DatabaseHelper.instance.getDataService();
                print(i);
                showSnackBar(context, 'Data Berhasil Dimasukkan (Offline)', 4);
              },
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
