import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/screens/purchase_order_offline/components/dropdown_search.dart';

import '../../../constants.dart';
import '../../../helper/database_helper.dart';
import '../../scanner/scanner_screen.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var noOG =
      'OGOF-SM-${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}}';

  // var _lokasi = null;

  // Future<dynamic> fetchOptions() async {
  //   var listLokasi = await DatabaseHelper.instance.getAllInventoryLocations();
  //   print(listLokasi);
  //   _lokasi = listLokasi;
  //   return listLokasi;
  // }

  Future<List<Map<String, dynamic>>> fetchData() async {
    return await DatabaseHelper.instance.getInventoryLocations();
  }

  // Future<List<Map<String, dynamic>>> fetchCustomers() async {
  //   try {
  //     final i = await DatabaseHelper.instance.getCustomers();
  //     print('sakadik');
  //     print(i);
  //     return i; // Return the fetched data
  //   } catch (e) {
  //     print('Error fetching customers: $e');
  //     return []; // Return an empty list or handle the error accordingly
  //   }
  // }

  void initState() {
    super.initState();
    // fetchCustomers();
    // fetchOptions().then((value) => _lokasi = value);
    // print(_lokasi);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            DropdownSearchWidget(),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData(), // Call your asynchronous function here
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for the future to complete
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // If there was an error while fetching data
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // When the future is complete, you can access the data
                  final data = snapshot.data;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Lokasi',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onChanged: (newValue) async {},
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
