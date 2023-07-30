import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shop_app/controllers/list_bt_controller.dart';
import '../constants.dart';
import '../shared_preferences/shared_token.dart';

class FormTapScreenController extends GetxController {
  RxList<dynamic> listLokasi = <dynamic>[].obs;
  RxList<String> listPo = <String>[].obs;
  RxList<dynamic> dataPurchaseOrderDetail = <dynamic>[].obs;
  RxString notes = ''.obs;

  RxInt lokasiSelect = 0.obs;
  // @override
  // Future onInit() async {
  //   print('Widget created!');
  //   await getlistLokasi();
  //   super.onInit();
  // }

  void chgLokasi(dynamic prop) {
    lokasiSelect.value = prop;
    update();
  }

  void setNotes(String prop) {
    notes.value = prop;
    // update();
  }

  String convertToQueryString(List<String> poList) {
    List<String> queryParameters = [];

    for (int i = 0; i < poList.length; i++) {
      String param = "id[$i]=${Uri.encodeQueryComponent("'${poList[i]}'")}";
      queryParameters.add(param);
    }

    return queryParameters.join('&');
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

      listLokasi.addAll(res);
      update();
    } catch (e) {
      print('Error sending POST request: $e');
    }
  }

  String queryStringPo = '';

  Future<void> myFunction() async {
    var listbChecked = Get.find<ListBtController>()
        .listBt
        .where((item) => item[16] == "1")
        .toList();
    List<String>? po;
    po = listbChecked.map((item) => item[0]).cast<String>().toList();
    // print('${po} EIN PO');

    dataPurchaseOrderDetail.clear();
    // Web API endpoint URLs
    final apiHost = kURL_ORIGIN; // Replace with your actual API host URL
    final company =
        await SharedToken.companyGetter(); // Replace with the company ID
    final token = await SharedToken
        .tokenGetter(); // Replace with your authentication token

    // Helper function to make GET requests
    Future<Map<String, dynamic>> getRequest(String endpoint) async {
      final response = await http.get(Uri.parse(endpoint));
      return json.decode(response.body);
    }

    // Helper function to make POST requests
    Future<Map<String, dynamic>> postRequest(String endpoint,
        {Map<String, String>? data}) async {
      final response = await http.post(Uri.parse(endpoint), body: data);
      return json.decode(response.body);
    }

    /*
    ===========
    RENDER CODE
    ===========
  */
    // Get data company by ID
    final url = '${apiHost}company/get-by-id/$company/$token';
    final req = await getRequest(url);
    final dataCompany = req['content'];

    // Get company code
    String companyCode = 'GM';
    if (dataCompany != null && dataCompany.isNotEmpty) {
      companyCode = dataCompany[0]['company_code'];
    }

    // Grouping Purchase Order
    final btgroup =
        'BT$companyCode${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}';

    // Get list purchase order by pogroup
    final url2 =
        '${apiHost}inventory-receipt/get-by-group/$company/$token?:ongroup=${btgroup}';
    // final options = {':ongroup': btgroup};
    final req2 = await postRequest(url2);
    int i = req2['content']?.length ?? 0;

    i = i + 1;

    //   // Render kode BT
    final kodeBT =
        'BT$companyCode${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${i.toString().padLeft(4, '0')}';
    /*
      ==================
      INVENTORY LOCATION
      ==================
    */
    // Get inventory location by company id
    final url3 = '${apiHost}inventory-location/get-raw/$company/$token';
    final req3 = await getRequest(url3);
    final dataLocation = req3['content'];
    // debugPrint('LOKDAT ${dataLocation}');

    /*
      ==============
      PURCHASE ORDER
      ==============
    */
    // final response = await http.post(Uri.parse(url4), body: options2);
    // debugPrint('${response.body}');

    final pores = convertToQueryString(po);

    final url4 = '${apiHost}purchase-order-detail/get-by-po-id-bulk/$token?';
    // print('${pores}');
    // return;
    final response = await http.post(Uri.parse('${url4}${pores}'));
    var dataPo = {};
    // print('${response.body}');
    dataPo['bt_group'] = btgroup;
    dataPo['note'] = await SharedToken.univGetterString('notes');
    dataPo['tanggal'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dataPo['penerima'] = await SharedToken.univGetterString('username');
    dataPo['company_id'] = await SharedToken.companyGetter();
    dataPo['inventory_location_id'] =
        await SharedToken.univGetterString('lokasi');

    String queryString = createQueryString(dataPo: dataPo);
    // print(queryString);

    queryStringPo = queryString;

    var re2 = jsonDecode(response.body);
    dataPurchaseOrderDetail.addAll(re2['content']);
  }

  Future<void> addTapBarang() async {
    final companyId = await SharedToken.companyGetter();
    final token = await SharedToken.tokenGetter();

    await http.post(
        Uri.parse('inventory-receipt/save-live-bulk/${companyId}/${token}'),
        body: {});
  }

  String createQueryString({dynamic? dataPo, dynamic? detailInv}) {
    List<String> queryParameters = [];

    dataPo?.forEach((key, value) {
      String param =
          "dataPo[${Uri.encodeQueryComponent(key)}]=${Uri.encodeQueryComponent(value.toString())}";
      queryParameters.add(param);
    });

    detailInv?.forEach((key, value) {
      String param =
          "detail_inv[${Uri.encodeQueryComponent(key)}]=${Uri.encodeQueryComponent(value.toString())}";
      queryParameters.add(param);
    });

    return queryParameters.join('&');
  }

  RxString tipe = 'SN'.obs;

  Map<String, dynamic> detail_inv = {};
  RxString noSN = ''.obs;
  RxString lastStatus = ''.obs;
  Future<String> scanAct(dynamic prop) async {
    if (noSN.value == '' && prop != noSN.value) {
      print('${noSN.value} WOI');
      noSN.value = prop;
      detail_inv['serial_number'] = noSN.value;
    } else {
      // Find the object with the given product_identifier without considering the model
      Map<String, dynamic>? result = dataPurchaseOrderDetail.firstWhere(
        (item) => item['product_identifier'] == prop,
        orElse: () => null, // Return null if no matching item is found
      );

// Check if the result is not null, i.e., a matching item was found
      if (result != null) {
        if (detail_inv['serial_number'] != null) {
          // noSN.value = prop;
          // update();
          // detail_inv['serial_number'] = noSN.value;

          // if (result['qty_total'] == result['qty_receive']) {
          //   return 'Barang Tidak Dapat Disimpan, Quantity Barang Sudah Melebihin Quantity Po';
          // }

          tipe.value = 'Identifier';
          // update();
          if (!detail_inv['serial_number'].contains(result['digit_penanda'])) {
            return 'SN TIDAK COCOK DENGAN DIGIT PENANDA';
          }

          detail_inv['identifier'] = prop;
          detail_inv['product_id'] = result['product_id'];
          detail_inv['po'] = result['purchase_order_id'];
          detail_inv['tipe'] = result['tipe'];
          detail_inv['btm'] = null;
          detail_inv['detail_btm'] = null;

          final companyId = await SharedToken.companyGetter();
          final token = await SharedToken.tokenGetter();

          String queryStringInv = createQueryString(detailInv: detail_inv);

          // String queryString = Uri(queryParameters: detail_inv).query;

          // final url =
          //     '${kURL_ORIGIN}inventory-receipt/save-live-bulk/${companyId}/${token}?${queryStringPo}${detail_inv}';
          // print('${url} here');

          // var response = await http.post(Uri.parse(url));

          // var res = jsonDecode(response.body);
// Your existing code
          final url =
              '${kURL_ORIGIN}inventory-receipt/save-live-bulk/${companyId}/${token}?${queryStringPo}${queryStringInv}';
          print('${url} here');

          try {
            var response = await http.post(Uri.parse(url));

            if (response.statusCode == 200) {
              // Successful response
              var res = jsonDecode(response.body);
              print(res['msg']);
              print(res['content']);
              print(res['success']);
              print(res['token_status']);

              print('ehe');
              myFunction();
              noSN.value = '';
              lastStatus.value = res['msg'];
              tipe.value = 'SN';

              return res['msg'];
              // Do something with the 'res' data
            } else {
              // Handle unsuccessful response (e.g., 404, 500, etc.)
              print('Request failed with status: ${response.statusCode}');
              print('Response body: ${response.body}');

              return 'Request failed with status: ${response.statusCode}';
              // return 'Response body: ${response.body}';
              // Add further error handling or notify the user accordingly
            }
          } catch (e) {
            // Handle exceptions that might occur during the request
            print('Error during HTTP request: $e');
            return 'Error during HTTP request: $e';
            // Add further error handling or notify the user accordingly
          }

          // return 'Data SU'
          //CLEAN DATA

          // final url =
          //     '${kURL_ORIGIN}/inventory-receipt/save-live-bulkDEMO/${companyId}/${token}';
        }
      }
    }
    return noSN.value;

    // else if (noSN.value == '' && result == null) {
    //   // Handle the case when no matching item is found
    //   print('${result} KO');
    //   print('No item found with product_identifier: $prop');
    //   noSN.value = prop;
    //   // update();
    //   detail_inv['serial_number'] = prop;
    // }
    // update();
    // print('A ${detail_inv}');
    return 'Kode Diterima';
  }
}
