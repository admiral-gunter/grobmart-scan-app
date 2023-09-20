import 'package:get/get.dart';
import 'package:shop_app/helper/database_helper.dart';

import '../../../shared_preferences/shared_token.dart';

class RetailTapOutController extends GetxController {
  RxMap snIdentifier = {}.obs;

  RxMap credentialBasic = {}.obs;

  // RxList dataTap = [].obs;

  void updateSnIdentifier(String key, dynamic value) {
    snIdentifier[key] = value;
  }

  void updateCredentialBasic(String key, dynamic value) {
    credentialBasic[key] = value;
  }

  Future insertDataOffline() async {
    var noOG =
        'OGOF-SM-${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}}}';
    Map<String, dynamic> data = {
      'sn': snIdentifier['sn'],
      'identifier': snIdentifier['identifier'],
      'location_id': credentialBasic['location'],
      'customer_id': await SharedToken.univGetterString('customer_id'),
      'creator': await SharedToken.univGetterString('username'),
      'code': noOG
    };
    // dataTap.add(data);
    // Map<String, dynamic> inserted =
    //     await DatabaseHelper.instance.insertInventoryValidasiHistory(data);
    // print(inserted);
    // snIdentifier.clear();
    // credentialBasic.clear();

    // return inserted;
  }

  Future<dynamic> insertDataOfflineTap(
      dynamic dataTap, dynamic customer) async {
    try {
      var noOG =
          'RTL-OFF-${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
      Map<String, dynamic> e = {'result': false, 'message': ''};
      // Map<String, dynamic> data = {
      //   'sn': snIdentifier['sn'],
      //   'identifier': snIdentifier['identifier'],
      //   'location_id': credentialBasic['location'],
      //   'customer_id': credentialBasic['customer'],
      //   'creator': await SharedToken.univGetterString('username'),
      //   'code': noOG
      // };

      for (var i = 0; i < dataTap.length; i++) {
        Map<String, dynamic> data = {
          'sn': dataTap[i]['sn'],
          'identifier': dataTap[i]['identifier'],
          'location_id': credentialBasic['location'],
          'customer_id': customer,
          'creator': await SharedToken.univGetterString('username'),
          'code': noOG
        };
        // final dataInsert = dataTap[i];
        var e = await DatabaseHelper.instance.insertRetailTapOut(data);
        if (!e['result']) {
          return e;
        }

        return e;
      }
    } catch (e) {
      return e;
    }
  }
}
