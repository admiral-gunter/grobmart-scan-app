import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/controllers/list_po_controller.dart';

import '../../../constants.dart';
import '../../form_tap/form_tap_screen.dart';
import '../../sign_in/sign_in_screen.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool displayBulkBtn = false;
  final ListPoController ctl = Get.put(ListPoController());
  // final FormTapScreenController ctl2 = Get.put(FormTapScreenController());

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final e = await ctl.getListBt();
    if (e == 'TOKEN_EMPTY') {
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    }
    print(e);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
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
                        // Navigator.pushNamed(context, FormTapScreen.routeName);
                      },
                      child: ListTile(
                        leading: Checkbox(
                          value: ctl.listBt[index][6] != 0,
                          onChanged: (value) {
                            setState(() {
                              ctl.listBt[index][6] = value! ? 1 : 0;

                              ctl.listBt.map((e) {
                                if (e[6] != 0) {
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
                            // ctl.listBt[index][4] == 'enable'
                            //     ? Text('Enable',
                            //         style: TextStyle(
                            //             fontSize: 14, color: Colors.green))
                            //     : ctl.listBt[index][4] == 'disable'
                            //         ? Text('Disable',
                            //             style: TextStyle(
                            //                 fontSize: 14, color: Colors.amber))
                            //         : Text('Incomplete',
                            //             style: TextStyle(
                            //                 fontSize: 14, color: Colors.red)),
                            //                    if (data['5'] == 'completed') {
                            //   return '<div style="text-align: center"><label class="label label-success">Completed</label></div>';
                            // }
                            // else if(data['5'] == 'close'){
                            //   return '<div style="text-align: center"><label class="label label-danger">Closed</label></div>';
                            // }
                            // else {
                            //   return '<div style="text-align: center"><label class="label label-warning">Incomplete</label></div>';
                            // }
                            // ctl.listBt[index][5] == 'completed'
                            //     ? Text('Completed',
                            //         style: TextStyle(
                            //             fontSize: 14, color: Colors.green))
                            //     : ctl.listBt[index][5] == 'close'
                            //         ? Text('Closed',
                            //             style: TextStyle(
                            //                 fontSize: 14, color: Colors.red))
                            //         : Text('Incomplete',
                            //             style: TextStyle(
                            //                 fontSize: 14, color: Colors.amber))
                          ],
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${ctl.listBt[index][0]}"),
                            Text(
                              "${ctl.listBt[index][1]}",
                              style: TextStyle(color: kTextColor, fontSize: 14),
                            ),
                            Text("${ctl.listBt[index][2]}",
                                style:
                                    TextStyle(color: kTextColor, fontSize: 14)),
                            Text("${ctl.listBt[index][3]}",
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
                OutlinedButton(
                  onPressed: () async {
                    await ctl.chgPage('prev');
                  },
                  child: Text(
                    '<',
                    style: TextStyle(color: kTextColor),
                  ),
                ),
                OutlinedButton(
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
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, FormTapScreen.routeName);
              },
              child: Text('BT Bulk', style: TextStyle(color: kTextColor)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: kPrimaryColor),
              ),
            ),
            // OutlinedButton(
            //   onPressed: () {
            //     Navigator.pushNamed(context, FormTapScreen.routeName);
            //   },
            //   child: Text('BT Bulk', style: TextStyle(color: kTextColor)),
            // )
          ],
        )
      ],
    );
  }
}
