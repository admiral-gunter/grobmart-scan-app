import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../shared_preferences/shared_token.dart';

class FormTapScreenController extends GetxController {
  RxList<dynamic> listLokasi = <dynamic>[].obs;

  @override
  Future onInit() async {
    print('Widget created!');
    await getlistLokasi();
    super.onInit();
  }

  Future getlistLokasi() async {
    try {
      final token = await SharedToken.tokenGetter();
      final companyId = await SharedToken.companyGetter();
      listLokasi.clear();

      var param = '?field=select2_gudang&tipe=1';
      var url = Uri.parse(
          kURL_ORIGIN + 'select2/get-raw/' + companyId + '/' + token! + param);

      var response = await http.post(url);

      var res = jsonDecode(response.body);

      debugPrint('${res}');

      listLokasi.addAll(res);
      update();
    } catch (e) {
      print('Error sending POST request: $e');
    }
  }
}
