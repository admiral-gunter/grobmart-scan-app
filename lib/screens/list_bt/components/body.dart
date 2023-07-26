import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/controllers/form_tap_screen_controller.dart';
import 'package:shop_app/controllers/list_bt_controller.dart';
import 'package:shop_app/screens/form_tap/form_tap_screen.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool displayBulkBtn = false;
  final ListBtController ctl = Get.put(ListBtController());
  // final FormTapScreenController ctl2 = Get.put(FormTapScreenController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
                itemCount: ctl.listBt.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        // print('${ctl.listBt[index]}');
                        // ctl2.listPo.add(ctl.listBt[index][0]);
                        Navigator.pushNamed(context, FormTapScreen.routeName);
                      },
                      child: ListTile(
                        leading: Checkbox(
                          value: ctl.listBt[index][16] != "0",
                          onChanged: (value) {
                            setState(() {
                              ctl.listBt[index][16] = value! ? "1" : "0";

                              ctl.listBt.map((e) {
                                if (e[16] != "0") {
                                  displayBulkBtn = true;
                                } else {
                                  displayBulkBtn = false;
                                }
                              });
                            });
                          },
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${ctl.listBt[index][4]}',
                                style: TextStyle(fontSize: 14)),
                            Text('${ctl.listBt[index][5]}',
                                style: TextStyle(fontSize: 14))
                          ],
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${ctl.listBt[index][0]}"),
                            Text(
                              "${ctl.listBt[index][14]}",
                              style: TextStyle(color: kTextColor, fontSize: 14),
                            ),
                            Text("${ctl.listBt[index][15]}",
                                style:
                                    TextStyle(color: kTextColor, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    await ctl.chgPage('prev');
                  },
                  child: Text(
                    '<',
                    style: TextStyle(color: kTextColor),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await ctl.chgPage('next');
                  },
                  child: Text(
                    '>',
                    style: TextStyle(color: kTextColor),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, FormTapScreen.routeName);
              },
              child: Text('BT Bulk', style: TextStyle(color: kTextColor)),
            )
          ],
        )
      ],
    );
  }
}
