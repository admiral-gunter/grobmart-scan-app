import 'package:get/get.dart';

class UniversalScannerData extends GetxController {
  RxMap snIdentifier = {}.obs;

  void updateSnIdentifier(String key, dynamic value) {
    snIdentifier[key] = value;
  }
}
