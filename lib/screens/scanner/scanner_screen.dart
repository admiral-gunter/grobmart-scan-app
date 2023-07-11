import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shop_app/helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../components/coustom_bottom_nav_bar.dart';
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
              final Uint8List? image = capture.image;

              // Set<Barcode> uniqueSet = Set<Barcode>.from(barcodes);

              // List<Barcode> resList = uniqueSet.toList();
              // Create a DateTime object
              DateTime dateTime = DateTime.now();

              // Format the DateTime object
              String formattedDateTime =
                  DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
              for (final barcode in barcodes) {
                Database db = await DatabaseHelper.instance.database;
                await db.insert('scanned_data', {
                  'id': barcode.rawValue,
                  'creator': 'pesatir',
                  'created_date': formattedDateTime
                });
                await Future.delayed(Duration(milliseconds: 1));

                setState(() {
                  _showMessage = true;
                  barcodeRawVal = barcode.rawValue;
                });

                // Delay again before hiding the message
                await Future.delayed(Duration(seconds: 2));

                setState(() {
                  _showMessage = false;
                });
              }

              Database db = await DatabaseHelper.instance.database;
              final e = await db.query("scanned_data");
              debugPrint('${e}');
            },
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
                        Text(
                          '$barcodeRawVal',
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
                        Text(
                          'Kode Diterima',
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
        ],
      ),
    );
  }
}