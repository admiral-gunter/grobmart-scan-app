import 'dart:convert';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:http/http.dart' as http;

import '../../components/coustom_bottom_nav_bar.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../helper/database_helper.dart';
import '../../shared_preferences/shared_token.dart';
import '../../size_config.dart';
import 'components/body.dart';

class MenuScreen extends StatefulWidget {
  static var routeName = '/menu';

  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final client = http.Client();

  Future<void> checkTokenAndNavigate() async {
    // Get the SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the token value
    String? token = prefs.getString('token');
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    // Check if the token exists
    if (token != null && currentRoute != MenuScreen.routeName) {
      // Token exists, redirect to another page
      Navigator.pushReplacementNamed(context, MenuScreen.routeName);
    } else if (token == null && currentRoute != SignInScreen.routeName) {
      // Token does not exist, stay on the current page or redirect to a login page
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    }
  }

  Future<void> initData() async {
    try {
      final token = await SharedToken.tokenGetter();
      final companyId = await SharedToken.companyGetter();

      var param = '?field=select2_gudang&tipe=1';
      var url = Uri.parse(
          '${kURL_ORIGIN}select2/get-raw/${companyId}/${token!}${param}');

      var response = await http.post(url);

      var res = jsonDecode(response.body);
      await DatabaseHelper.instance.insertDatainventoryLocation(res);

      //       http://localhost/grobx2023/api/sale-wholesale-customer/get/3/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJTaW1hIiwiYXVkIjoiU2ltYSIsImlhdCI6MTY5MzY2NzQ2NCwidXNlcm5hbWUiOiJTaW1hIn0.nMfOLRkDkWLgr4cMkup5Gq0DSU6AtvVMyGTPYL70kIs?draw=1&columns[0][data]&columns[0][name]&columns[0][searchable]=true&columns[0][orderable]=false&columns[0][search][value]&columns[0][search][regex]=false&columns[1][data]&columns[1][name]&columns[1][searchable]=true&columns[1][orderable]=false&columns[1][search][value]&columns[1][search][regex]=false&columns[2][data]=email&columns[2][name]&columns[2][searchable]=true&columns[2][orderable]=false&columns[2][search][value]&columns[2][search][regex]=false&columns[3][data]=mobile&columns[3][name]&columns[3][searchable]=true&columns[3][orderable]=false&columns[3][search][value]&columns[3][search][regex]=false&columns[4][data]=status&columns[4][name]&columns[4][searchable]=true&columns[4][orderable]=false&columns[4][search][value]&columns[4][search][regex]=false&columns[5][data]=date_added&columns[5][name]&columns[5][searchable]=true&columns[5][orderable]=false&columns[5][search][value]&columns[5][search][regex]=false&columns[6][data]&columns[6][name]&columns[6][searchable]=true&columns[6][orderable]=false&columns[6][search][value]&columns[6][search][regex]=false&start=0&length=999999&search[value]&search[regex]=false
      url = Uri.parse(
          '${kURL_ORIGIN}sale-wholesale-customer/get/${companyId}/${token}?draw=1&columns[0][data]&columns[0][name]&columns[0][searchable]=true&columns[0][orderable]=false&columns[0][search][value]&columns[0][search][regex]=false&columns[1][data]&columns[1][name]&columns[1][searchable]=true&columns[1][orderable]=false&columns[1][search][value]&columns[1][search][regex]=false&columns[2][data]=email&columns[2][name]&columns[2][searchable]=true&columns[2][orderable]=false&columns[2][search][value]&columns[2][search][regex]=false&columns[3][data]=mobile&columns[3][name]&columns[3][searchable]=true&columns[3][orderable]=false&columns[3][search][value]&columns[3][search][regex]=false&columns[4][data]=status&columns[4][name]&columns[4][searchable]=true&columns[4][orderable]=false&columns[4][search][value]&columns[4][search][regex]=false&columns[5][data]=date_added&columns[5][name]&columns[5][searchable]=true&columns[5][orderable]=false&columns[5][search][value]&columns[5][search][regex]=false&columns[6][data]&columns[6][name]&columns[6][searchable]=true&columns[6][orderable]=false&columns[6][search][value]&columns[6][search][regex]=false&start=0&length=999999&search[value]&search[regex]=false');
      response = await http.post(url);
      res = jsonDecode(response.body);
      // print(res);
      await DatabaseHelper.instance.insertDataCustomer(res['data']);
    } catch (e) {
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
      print('ERROR following: $e');
    }
  }

  @override
  void dispose() {
    client.close(); // Close the client when the widget is disposed
    super.dispose();
  }

  // Future<void> syncDataOffline() async {
  //   try {
  //     var dat = await DatabaseHelper.instance.getDataInvHistory();
  //     var dat1 = jsonEncode(dat);
  //     final url = Uri.parse(
  //         '${kURL_ORIGIN}sync-insert-po-offline?table=po&data=${dat1}');
  //     final response = await client.post(
  //       url,
  //       headers: {
  //         'Content-Type':
  //             'application/json', // Set the appropriate content type
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Request Sync Data successful'),
  //         ),
  //       );
  //       print('Response data: ${response.body}');
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(
  //               'Request Sync Data failed with status code: ${response.statusCode}'),
  //         ),
  //       );
  //       print('Response data: ${response.body}');
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Request Sync Data error: $e'),
  //       ),
  //     );
  //     print('Request error: $e');
  //   } finally {
  //     client.close(); // Close the client when done
  //   }
  // }

  Future<void> syncDataOfflineDynamic(String tipe) async {
    try {
      var dat = null;
      var dat1 = '';
      if (tipe == 'po') {
        dat = await DatabaseHelper.instance.getDataInvHistory();
        print(dat);
        dat1 = jsonEncode(dat);
      } else if (tipe == 'service') {
        dat = await DatabaseHelper.instance.getDataService();
        dat1 = jsonEncode(dat);
      } else if (tipe == 'pindah_gudang') {
        dat = await DatabaseHelper.instance.getDataPindahGudang();
        dat1 = jsonEncode(dat);
      } else if (tipe == 'out_grosir') {
        dat = await DatabaseHelper.instance.getGrosirOut();
        dat1 = jsonEncode(dat);
      } else if (tipe == 'out_retail') {
        dat = await DatabaseHelper.instance.getRetailOut();
        dat1 = jsonEncode(dat);
      }
      final body = {'data': dat1};

      final url =
          Uri.parse('${kURL_ORIGIN}sync-insert-po-offline?table=${tipe}');
      final response = await client.post(url,
          headers: {
            'Content-Type':
                'application/x-www-form-urlencoded' // Set the appropriate content type
          },
          body: body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request Sync Data successful'),
          ),
        );
        print('Response data: ${response.body}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Request Sync Data failed with status code: ${response.statusCode}'),
          ),
        );
        print('Response data: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request Sync Data error: $e'),
        ),
      );
      print('Request error: $e');
    }
    // finally {
    //   client.close(); // Close the client when done
    // }
  }

  Future<void> syncData() async {
    try {
      await syncDataOfflineDynamic('po');
      await Future.delayed(Duration(seconds: 3));
      await syncDataOfflineDynamic('service');
      await Future.delayed(Duration(seconds: 3));
      await syncDataOfflineDynamic('pindah_gudang');
      await Future.delayed(Duration(seconds: 3));
      await syncDataOfflineDynamic('out_grosir');
      await Future.delayed(Duration(seconds: 3));
      await syncDataOfflineDynamic('out_retail');
    } catch (e) {
      print("Async operation failed: $e");
    }
  }

  @override
  void initState() {
    DatabaseHelper.instance.getRetailOut().then((value) {
      print('nanu');
      print(value);
    });
    super.initState();
    checkTokenAndNavigate();
    initData();
    syncData();
    // syncDataOfflineDynamic('po').then((value) =>
    //     syncDataOfflineDynamic('service')
    //         .then((value) => syncDataOfflineDynamic('pindah_gudang')));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
