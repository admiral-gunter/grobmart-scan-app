import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shop_app/helper/database_helper.dart';
import 'package:shop_app/shared_preferences/shared_token.dart';
import 'package:sqflite/sqflite.dart';
import '../../components/coustom_bottom_nav_bar.dart';
import '../../constants.dart';
import '../../controllers/form_tap_screen_controller.dart';
import '../../enums.dart';
import 'components/body.dart';

class ScannerScreen extends StatefulWidget {
  static var routeName = '/scanner';

  ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _showMessage = false;
  String? barcodeRawVal = '';
  String? mesage = '';
  int _tipe = 0;

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dialog Title'),
          content: Text('This is the content of the dialog.'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  MobileScannerController cameraController =
      MobileScannerController(detectionSpeed: DetectionSpeed.normal);

  void initState() {
    // To fix on start error
    cameraController.stop();
    super.initState();
  }

  bool _tr = true;

  final FormTapScreenController ctl = Get.put(FormTapScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        alignment: FractionalOffset.center,
        children: [
          MobileScanner(
            controller: cameraController,
            fit: BoxFit.contain,
            startDelay: true,
            onDetect: (capture) async {
              final List<Barcode> barcodes = capture.barcodes.toList();
              // final Uint8List? image = capture.image;

              // Set<Barcode> uniqueSet = Set<Barcode>.from(barcodes);

              // List<Barcode> resList = uniqueSet.toList();
              // Create a DateTime object
              // DateTime dateTime = DateTime.now();

              // Format the DateTime object
              // String formattedDateTime =
              // DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
              for (final barcode in barcodes) {
                if (_tipe == 0) {
                  setState(() {
                    _tipe = 1;
                  });
                } else {
                  setState(() {
                    _tipe = 0;
                  });
                }

                // Database db = await DatabaseHelper.instance.database;
                // await db.insert('scanned_data', {
                //   'id': barcode.rawValue,
                //   'creator': await SharedToken.univGetterString('username'),
                //   'created_date': formattedDateTime
                // });
                // await Future.delayed(Duration(milliseconds: 1));
                final msg = await ctl.scanAct(barcode.rawValue);
                if (ctl.errorSound.value) {
                  AudioPlayer().play(AssetSource('audio/failed.mp3'));
                } else {
                  AudioPlayer().play(AssetSource('audio/success.mp3'));
                }
                setState(() {
                  _showMessage = true;
                  barcodeRawVal = '${barcode.rawValue}';
                  mesage = msg;
                });

                // Delay again before hiding the message
                await Future.delayed(Duration(seconds: 5));

                setState(() {
                  _showMessage = false;
                });
              }
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${ctl.lastStatus.value}"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('SN  '),
                              Text('${ctl.detail_inv['serial_number'] ?? ''}')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Identifier '),
                              Text('${ctl.detail_inv['identifier'] ?? ''} ')
                            ],
                          ),
                        ],
                      )),
                  OutlinedButton(
                    onPressed: () {
                      // Add your button click logic here.
                      ctl.noSN.value = '';
                      ctl.lastStatus.value = '';
                      ctl.detail_inv['identifier'] = null;
                      ctl.detail_inv['serial_number'] = null;
                    },
                    child: Text('RESET SN DAN IDENTIFIER',
                        style: TextStyle(color: kPrimaryColor, fontSize: 10)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      side: BorderSide(width: 1, color: kPrimaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: _showMessage
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _showMessage = false;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            'BARCODE : ${barcodeRawVal} (${ctl.tipe})',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: <Shadow>[
                                Shadow(
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                Shadow(
                                  blurRadius: 8.0,
                                  color: Color.fromARGB(125, 0, 0, 255),
                                ),
                              ],
                            ),
                          ).animate().fade(duration: 500.ms),
                        ),
                        Text(
                          '${mesage}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              Shadow(
                                blurRadius: 8.0,
                                color: Color.fromARGB(125, 0, 0, 255),
                              ),
                            ],
                          ),
                        ).animate().fade(duration: 500.ms),
                      ],
                    ),
                  )
                : null,
          ),
          Obx(() {
            if (ctl.lastStatus.value != '') {
              AudioPlayer().play(AssetSource('audio/success.mp3'));

              // Conditionally navigate back when shouldPop becomes true
              Future.delayed(Duration.zero, () {
                // Navigator.pop(context);
                cameraController.stop();
              });
            }
            return Text('');
          }),
          Obx(
            () => Align(
              alignment: Alignment.center,
              child: ctl.lastStatus.value != ''
                  ? Container(
                      width: 400,
                      height: 150,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${ctl.lastStatus.value}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     ctl.noSN.value = '';
                          //     ctl.lastStatus.value = '';
                          //   },
                          //   child: Text('Close'),
                          // ),
                          OutlinedButton(
                            onPressed: () {
                              // Add your button click logic here.
                              ctl.noSN.value = '';
                              ctl.lastStatus.value = '';
                              ctl.detail_inv['identifier'] = null;
                              ctl.detail_inv['serial_number'] = null;
                              // Navigator.pop(context);
                            },
                            child: Text('Close',
                                style: TextStyle(color: kPrimaryColor)),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              side: BorderSide(width: 1, color: kPrimaryColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
          )
        ],
      ),
    );
  }
}
