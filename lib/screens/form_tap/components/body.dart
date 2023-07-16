import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/controllers/form_tap_screen_controller.dart';
import 'package:shop_app/screens/scanner/scanner_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    // Get.put(ListBtController());
    final FormTapScreenController ctl = Get.put(FormTapScreenController());
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
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
                //  controller: _passwordController,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              GetBuilder<FormTapScreenController>(
                builder: (controller) => DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select an option',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (newValue) {},
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
              // TextFormField(
              //   decoration: InputDecoration(
              //     labelText: 'Lokasi',
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
              SizedBox(
                height: 30,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'SN',
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

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Type',
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

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ScannerScreen.routeName);
                    },
                    child: Text('Scan SN dan Identifier',
                        style: TextStyle(color: kPrimaryColor)),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: const Text('Submit',
                        style: TextStyle(color: kPrimaryColor)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
