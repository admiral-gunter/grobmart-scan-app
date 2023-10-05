import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press here
        // Return true to allow the back navigation or false to block it
        // You can perform custom logic or show a dialog before allowing the navigation

        // For example, you can show an alert dialog and only allow the navigation if the user confirms
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Exit'),
              content: Text('Are you sure you want to exit?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    // Pop the current route and allow the back navigation
                    Navigator.of(context).pop(true);
                  },
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    // Stay on the current route and block the back navigation
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
        // By default, block the back navigation
        return false;
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              HomeHeader(),
              SizedBox(height: getProportionateScreenWidth(10)),
              DiscountBanner(),
              Categories(),
              SpecialOffers(),
              SizedBox(height: getProportionateScreenWidth(30)),
              PopularProducts(),
              SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        ),
      ),
    );
  }
}
