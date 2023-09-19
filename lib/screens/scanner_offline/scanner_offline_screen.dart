import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shop_app/screens/purchase_order_offline/purchase_order_offline_screen.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shop_app/helper/database_helper.dart';

import 'controller/scanner_offline_controller.dart';

class ScannerOfflineScreen extends StatefulWidget {
  static var routeName = '/scannerOffline';

  ScannerOfflineScreen({Key? key}) : super(key: key);

  @override
  State<ScannerOfflineScreen> createState() => _ScannerOfflineScreenState();
}

class _ScannerOfflineScreenState extends State<ScannerOfflineScreen> {
  MobileScannerController cameraController =
      MobileScannerController(detectionSpeed: DetectionSpeed.normal);

  Map<String, dynamic> dataSNIdentifier = {'sn': null, 'identifier': null};
  String curKey = 'sn';
  final ScannerOfflineController ctl = Get.put(ScannerOfflineController());

  void initState() {
    // To fix on start error
    cameraController.stop();
    super.initState();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('DATA TERDETEKSI',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('TIPE : ${curKey}\n'
              'VALUE : ${dataSNIdentifier[curKey]}\n'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () async {
                ctl.updateSnIdentifier(curKey, dataSNIdentifier[curKey]);

                if (curKey == 'sn') {
                  setState(() {
                    curKey = 'identifier';
                  });
                } else {
                  setState(() {
                    curKey = 'sn';
                  });
                  ctl.insertDataOffline();
                }

                // final e = DatabaseHelper.instance
                //     .getDataInvHistory()
                //     .then((value) => print(value));
                // if (curKey == 'identifier') {
                //   setState(() {
                //     curKey = 'sn';
                //   });
                //   ctl.insertDataOffline();
                // }
                cameraController.start();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
        actions: [
          IconButton(
            color: Colors.black,
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
            color: Colors.black,
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
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          // final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            dataSNIdentifier[curKey] = barcode.rawValue;
          }
          cameraController.stop();
          AudioPlayer().play(AssetSource('audio/success.mp3'));

          _dialogBuilder(context).then((value) {});
        },
      ),
    );
  }
}
