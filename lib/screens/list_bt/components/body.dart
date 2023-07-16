import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/controllers/list_bt_controller.dart';
import 'package:shop_app/screens/form_tap/form_tap_screen.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List dataListBT = [
    [
      "PO-SM-2023-07-11-0173",
      "4",
      "2023-07-11",
      null,
      "enable",
      "completed",
      "",
      "beli",
      "desty_jenar",
      "3",
      null,
      "POSM20230711",
      "2023-07-11 16:46:10",
      "2023-07-11 17:13:32",
      "SARANA KENCANA MULYA",
      "LSO3L4470301",
      "0"
    ],
    [
      "PO-SM-2023-07-11-0172",
      "4",
      "2023-07-11",
      null,
      "enable",
      "completed",
      "",
      "beli",
      "desty_jenar",
      "3",
      null,
      "POSM20230711",
      "2023-07-11 16:44:45",
      "2023-07-11 17:12:56",
      "SARANA KENCANA MULYA",
      "LSO3L4470302",
      "0"
    ],
    [
      "PO-SM-2023-07-11-0171",
      "4",
      "2023-07-11",
      null,
      "enable",
      "completed",
      "",
      "beli",
      "desty_jenar",
      "3",
      null,
      "POSM20230711",
      "2023-07-11 16:36:21",
      "2023-07-11 17:02:27",
      "SARANA KENCANA MULYA",
      "LSO3L4470300",
      "0"
    ],
    [
      "PO-SM-2023-07-11-0170",
      "20",
      "2023-07-11",
      null,
      "enable",
      "completed",
      "CHANGHONG KE G3",
      "beli",
      "sahnaz",
      "3",
      null,
      "POSM20230711",
      "2023-07-11 16:32:07",
      "2023-07-11 16:35:07",
      "Changhong",
      "11255707",
      "0"
    ],
    [
      "PO-SM-2023-07-11-0169",
      "4",
      "2023-07-11",
      null,
      "enable",
      "dispatched",
      "",
      "beli",
      "desty_jenar",
      "3",
      null,
      "POSM20230711",
      "2023-07-11 16:28:58",
      "2023-07-11 16:29:03",
      "SARANA KENCANA MULYA",
      "LSO3L0E61678",
      "0"
    ],
    [
      "PO-SM-2023-07-11-0168",
      "20",
      "2023-07-11",
      null,
      "enable",
      "completed",
      "CHANGHONG KE G3",
      "beli",
      "sahnaz",
      "3",
      null,
      "POSM20230711",
      "2023-07-11 16:26:51",
      "2023-07-11 16:34:27",
      "Changhong",
      "11255708",
      "0"
    ],
    [
      "PO-SM-2023-07-11-0167",
      "4",
      "2023-07-11",
      null,
      "enable",
      "completed",
      "",
      "beli",
      "yunisa",
      "3",
      null,
      "POSM20230711",
      "2023-07-11 14:19:25",
      "2023-07-11 16:42:54",
      "SARANA KENCANA MULYA",
      "LSO3L4470296",
      "0"
    ],
    [
      "PO-SM-2023-07-11-0166",
      "4",
      "2023-07-11",
      null,
      "enable",
      "completed",
      "",
      "beli",
      "yunisa",
      "3",
      null,
      "POSM20230711",
      "2023-07-11 14:17:32",
      "2023-07-11 16:17:41",
      "SARANA KENCANA MULYA",
      "LSO3L4470297",
      "0"
    ],
    [
      "PO-SM-2023-07-11-0165",
      "4",
      "2023-07-11",
      null,
      "enable",
      "completed",
      "",
      "beli",
      "yunisa",
      "3",
      null,
      "POSM20230711",
      "2023-07-11 14:14:46",
      "2023-07-11 16:20:26",
      "SARANA KENCANA MULYA",
      "LSO3L4470298",
      "0"
    ],
    [
      "PO-SM-2023-07-11-0164",
      "4",
      "2023-07-11",
      null,
      "enable",
      "completed",
      "",
      "beli",
      "yunisa",
      "3",
      null,
      "POSM20230711",
      "2023-07-11 14:12:50",
      "2023-07-11 16:09:14",
      "SARANA KENCANA MULYA",
      "LSO3L4470299",
      "0"
    ]
  ];

  bool displayBulkBtn = false;

  @override
  Widget build(BuildContext context) {
    final ListBtController ctl = Get.put(ListBtController());
    ctl.getListBt();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
                itemCount: dataListBT.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, FormTapScreen.routeName);
                      },
                      child: ListTile(
                        leading: Checkbox(
                          value: dataListBT[index][16] != "0",
                          onChanged: (value) {
                            setState(() {
                              dataListBT[index][16] = value! ? "1" : "0";

                              dataListBT.map((e) {
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
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Terima',
                                style: TextStyle(color: kTextColor),
                              ),
                            ),
                          ],
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${dataListBT[index][0]}"),
                            Text(
                              "${dataListBT[index][14]}",
                              style: TextStyle(color: kTextColor, fontSize: 14),
                            ),
                            Text("${dataListBT[index][15]}",
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
                  onPressed: () {},
                  child: Text(
                    '<',
                    style: TextStyle(color: kTextColor),
                  ),
                ),
                TextButton(
                  onPressed: () {},
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
