import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/controllers/form_tap_screen_controller.dart';
import 'package:shop_app/screens/scanner/scanner_screen.dart';
import 'package:shop_app/shared_preferences/shared_token.dart';

import '../../../controllers/list_bt_controller.dart';

class ObjectLokasi {
  final String id;
  final String text;

  ObjectLokasi(this.id, this.text);
}

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final e = Get.put(ListBtController());
  final FormTapScreenController ctl = Get.put(FormTapScreenController());

  @override
  void initState() {
    super.initState();
    ctl.getlistLokasi();
    ctl.myFunction();
    debugPrint('oke run');
  }

  Future<String> _getUsername() async {
    return await SharedToken.univGetterString('username');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // TextFormField(
            //   decoration: InputDecoration(
            //     labelText: 'Penerima',
            //     labelStyle: TextStyle(
            //       color: Colors.black87,
            //       fontSize: 17,
            //     ),
            //   ),
            //   style: TextStyle(
            //     color: Colors.black87,
            //     fontSize: 17,
            //   ),
            //   //  controller: _passwordController,

            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter some text';
            //     }
            //     return null;
            //   },
            // ),
            FutureBuilder<String>(
              future: _getUsername(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Future hasn't completed yet, you can show a loading indicator here.
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // An error occurred while fetching the username, handle it accordingly.
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Future completed successfully, use the value as the initialValue
                  final String initialValue = snapshot.data ?? '';
                  return TextFormField(
                    initialValue: initialValue,
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
                  );
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            GetBuilder<FormTapScreenController>(
              builder: (controller) => DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Lokasi',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (newValue) {
                  ctl.chgLokasi(newValue);
                },
                items: controller.listLokasi.map((item) {
                  final objectLokasi =
                      ObjectLokasi(item['id'].toString(), item['text']);
                  return DropdownMenuItem<String>(
                    value: objectLokasi.id,
                    child: Text(objectLokasi.text),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                hintMaxLines: 5,
                labelText: 'Note',
                labelStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                ),
              ),
              style: TextStyle(
                color: Colors.black87,
                fontSize: 17,
              ),
              //  controller: _passwordController,
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => SizedBox(
                height: MediaQuery.of(context).size.height * 0.28,
                child: ctl.dataPurchaseOrderDetail.length == 0
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var item in ctl.dataPurchaseOrderDetail)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('${item['purchase_order_id']}')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          '${item['product_identifier']} - ${item['digit_penanda'] ?? ''} - ${item['digit_penanda2'] ?? ''}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          '${item['product_name']}   ${item['qty_receive']} / ${item['qty_total']}'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              )
                          ],
                        ),
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                // TextButton(
                //   onPressed: () {
                //     Navigator.pushNamed(context, ScannerScreen.routeName);
                //   },
                //   child: Text('Scan SN dan Identifier',
                //       style: TextStyle(color: kPrimaryColor)),
                // ),
                // TextButton(
                //   onPressed: () {
                //     if (_formKey.currentState!.validate()) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(content: Text('Processing Data')),
                //       );
                //     }
                //   },
                //   child: const Text('Submit',
                //       style: TextStyle(color: kPrimaryColor)),
                // ),
                OutlinedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
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
            ),
          ],
        ),
      ),
    );
  }
}
