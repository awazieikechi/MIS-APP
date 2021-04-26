import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:niia_mis_app/widgets/ShowMessage.dart';
import 'package:store_redirect/store_redirect.dart';

class HallBookingRoute extends StatefulWidget {
  @override
  _HallBookingRouteState createState() => _HallBookingRouteState();
}

class _HallBookingRouteState extends State<HallBookingRoute> {
  var _installedapp;
  String _packageName;

  @override
  void initState() {
    getApps();
    super.initState();
  }

  void getApps() async {
    if (Platform.isAndroid) {
      print(await AppAvailability.isAppEnabled("com.android.chrome"));
      // Returns: true
      try {
        _installedapp =
            await AppAvailability.isAppEnabled("com.android.chrome33323223");
        _packageName = "com.android.chrome";
      } on PlatformException catch (ex) {
        ShowMessage().showNotification('Hall Booking App is not installed.');
        StoreRedirect.redirect(androidAppId: "com.android.chrome");
      }
    }

    if (Platform.isIOS) {
      print(await AppAvailability.checkAvailability("com.android.chrome"));
      // Returns: Map<String, String>{app_name: Chrome, package_name: com.android.chrome, versionCode: null, version_name: 55.0.2883.91}
      try {
        _installedapp =
            await AppAvailability.checkAvailability("com.android.chrome");
      } on PlatformException catch (ex) {
        ShowMessage().showNotification('Hall Booking App is not installed.');
        StoreRedirect.redirect(iOSAppId: "585027354");
      }
    }

    if (_installedapp) {
      AppAvailability.launchApp(_packageName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
