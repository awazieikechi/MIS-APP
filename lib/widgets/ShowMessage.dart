import 'package:get/get.dart';
import 'package:niia_mis_app/widgets/size_config.dart';
import 'package:flutter/material.dart';

class ShowMessage {
  BuildContext context;

  void showNotification(String message) {
    Get.snackbar(
      'Status!!',
      message,
      messageText: Text(message,
          style: TextStyle(
              fontSize: 2.5 * SizeConfig.safeBlockVertical,
              color: Colors.white)),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      duration: Duration(seconds: 20),
      leftBarIndicatorColor: Colors.blue[300],
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue[300],
      ),
    );
  }
}
