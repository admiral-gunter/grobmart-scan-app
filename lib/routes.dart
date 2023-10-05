import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/details/details_screen.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shop_app/screens/form_tap/form_tap_screen.dart';
import 'package:shop_app/screens/grosir_tap_out/grosir_tap_out.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/list_barcodes/list_barcodes_screen.dart';
import 'package:shop_app/screens/purchase_order/purchase_order_screen.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';
import 'package:shop_app/screens/menu/menu_screen.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';
import 'package:shop_app/screens/pindah_gudang_offline/pindah_gudang_offline_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/retail_tap_out/retail_tap_out_screen.dart';
import 'package:shop_app/screens/scanner/scanner_screen.dart';
import 'package:shop_app/screens/service_offline/service_offline_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'package:shop_app/screens/universal_scannner/controller/universal_scanner_data.dart';

import 'screens/purchase_order_offline/purchase_order_offline_screen.dart';
import 'screens/scanner_offline/scanner_offline_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  ScannerScreen.routeName: (context) => ScannerScreen(),
  MenuScreen.routeName: (context) => MenuScreen(),
  ListBarcodesScreen.routeName: (context) => ListBarcodesScreen(),
  FormTapScreen.routeName: (context) => FormTapScreen(),
  ListPoScreen.routeName: (context) => ListPoScreen(),
  PurchaseOrderOfflineScreen.routeName: (context) =>
      PurchaseOrderOfflineScreen(),
  ScannerOfflineScreen.routeName: (context) => ScannerOfflineScreen(),
  ServiceOfflineScreen.routeName: (context) => ServiceOfflineScreen(),
  '/pindah-gudang-offline-terima': (context) =>
      PindahGudangOfflineScreen(tipe: 'terima'),
  '/pindah-gudang-offline-keluar': (context) =>
      PindahGudangOfflineScreen(tipe: 'keluar'),
  GrosirTapOut.routeName: (context) => GrosirTapOut(),
  RetailTapOutScreen.routeName: (context) => RetailTapOutScreen()
};
