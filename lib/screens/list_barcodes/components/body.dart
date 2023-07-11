import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:sqflite/sqflite.dart';

import '../../../helper/database_helper.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List _listScan = [];
  Future<List<Map<String, dynamic>>> fetchData() async {
    Database db = await DatabaseHelper.instance.database;
    final e = await db.query("scanned_data");
    _listScan = e;
    debugPrint('${e}');

    debugPrint('sakadik');

    return e;
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    fetchData();

    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _listScan.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Column(
              children: [
                Center(child: Text('data')),
                Text('${_listScan[index]['id']}'),
              ],
            ),
          );
        });
  }
}
