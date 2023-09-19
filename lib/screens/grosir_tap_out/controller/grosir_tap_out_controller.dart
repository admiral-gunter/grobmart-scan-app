import 'package:get/get.dart';
import 'package:shop_app/helper/database_helper.dart';

import '../../../shared_preferences/shared_token.dart';

class GrosirTapOutController extends GetxController {
  RxMap snIdentifier = {}.obs;

  RxMap credentialBasic = {}.obs;

  RxList dataTap = [].obs;

  void updateSnIdentifier(String key, dynamic value) {
    snIdentifier[key] = value;
  }

  void updateCredentialBasic(String key, dynamic value) {
    credentialBasic[key] = value;
  }

  Future<Map<String, dynamic>> insertDataOffline() async {
    var noOG =
        'OGOF-SM-${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().millisecondsSinceEpoch}}';
    Map<String, dynamic> data = {
      'sn': snIdentifier['sn'],
      'identifier': snIdentifier['identifier'],
      'location_id': credentialBasic['location'],
      'customer_id': credentialBasic['customer'],
      'creator': await SharedToken.univGetterString('username'),
      'code': noOG
    };
    dataTap.add(data);
    Map<String, dynamic> inserted =
        await DatabaseHelper.instance.insertInventoryValidasiHistory(data);
    print(inserted);
    snIdentifier.clear();
    credentialBasic.clear();

    return inserted;
  }
}
