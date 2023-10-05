import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../scanner_offline/controller/scanner_offline_controller.dart';
import 'controller/universal_scanner_data.dart';

class UniversalScannerSCreen extends StatefulWidget {
  final dynamic goBackRouteName;
  UniversalScannerSCreen({Key? key, required this.goBackRouteName})
      : super(key: key);

  @override
  State<UniversalScannerSCreen> createState() => _UniversalScannerSCreenState();
}

class _UniversalScannerSCreenState extends State<UniversalScannerSCreen> {
  MobileScannerController cameraController =
      MobileScannerController(detectionSpeed: DetectionSpeed.normal);

  Map<String, dynamic> dataSNIdentifier = {'sn': null, 'identifier': null};
  var curKey = 'sn';
  final UniversalScannerData ctl = Get.put(UniversalScannerData());

  void initState() {
    // To fix on start error
    ctl.clearSnIdentifier();
    cameraController.stop();
    super.initState();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      barrierDismissible: false,
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
                try {
                  ctl.updateSnIdentifier(curKey, dataSNIdentifier[curKey]);

                  if (curKey == 'sn') {
                    setState(() {
                      curKey = 'identifier';
                    });
                  } else {
                    setState(() {
                      curKey = 'sn';
                    });
                    ctl.addItemScan();
                  }
                  print(ctl.itemScanned);
                  cameraController.start();
                  Navigator.of(context).pop();
                } catch (e) {
                  AudioPlayer().play(AssetSource('audio/failed.mp3'));
                }
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, widget.goBackRouteName),
        ),
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
