import 'package:niia_mis_app/widgets/ShowMessage.dart';
import 'package:niia_mis_app/network_utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niia_mis_app/pages/home.dart';
import 'package:get/get.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:niia_mis_app/widgets/remitadata.dart';
import 'package:niia_mis_app/widgets/remitaresponsedata.dart';
import 'dart:convert';

class RemitaCustomGateway extends StatefulWidget {
  final RemitaData data;

  RemitaCustomGateway({this.data});

  @override
  _RemitaCustomGatewayState createState() =>
      _RemitaCustomGatewayState(data: data);
}

class _RemitaCustomGatewayState extends State<RemitaCustomGateway> {
  final RemitaData data;
  var resultfirstname;

  _RemitaCustomGatewayState({this.data});

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(data);

    return WebViewPlus(
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        controller.loadString("""
           <!DOCTYPE html>
<html lang="en">
  <body onload="makePayment()">
    <script>
    var onSuccessRemitaCall;
    var onErrRemitaCall;
    var resultmessage;
    
      function makePayment() {
        console.log("${data.total}");
        var paymentEngine = RmPaymentEngine.init({
          key:
            "TklJQXw0MjA3MTM3NDkyfDQ3MTJhMTI5YzAxOTk2MDI2MjkyZjM5YTc5YzczOGYzNGM0NGMyMDAzMmM2NzNjODQ3NDljMTZiMGUwNTNlMmRkZmU5OTQ3OTg3MTQzMDFhZGVkNjhlMmY4YTBiNjEyNzY2Y2ZjMDVlOGE0MjBiMDE0MDQyYzQzZDdmYWJlNDQx",
          email: "${data.email}",
          currency: "NGN",
          firstName: "${data.firstname}",
          lastName: "${data.lastname}",
          customerId: "${data.email}",
          phoneNumber: "${data.phonenumber}",
          transactionId: "${data.refCode}",
          narration: "GIFMIS Revenue Reference Number: 1000184417",
          amount: "${data.total}",

          onSuccess: function (response) {
            console.log(JSON.stringify(response));
            resultmessage = JSON.stringify(response);
            onSuccessRemitaCall.postMessage(resultmessage);
          },
          onError: function (response) {
            console.log(JSON.stringify(response));
            resultmessage = JSON.stringify(response);
            onErrRemitaCall.postMessage(resultmessage);
          },
          onClose: function () {
            console.log("closed");
          },
        });
        paymentEngine.openIframe();
      }
    </script>
    <script
      type="text/javascript"
      src="https://remitademo.net/payment/v1/remita-pay-inline.bundle.js"
      \
    ></script>
  </body>
</html>
      """);
      },
      javascriptChannels: Set.from(
        [
          JavascriptChannel(
              name: 'onSuccessRemitaCall',
              onMessageReceived: (JavascriptMessage message) {
                print('message.message Success: ${message.message}');
                final remitaPaymentResponse =
                    remitaPaymentResponseFromJson(message.message);
                print(remitaPaymentResponse.paymentReference);
                print(data.total);
                processPayment(
                    remitaPaymentResponse.paymentReference, data.total);
              }),
          JavascriptChannel(
              name: 'OnErrorRemitaCall',
              onMessageReceived: (JavascriptMessage message) {
                print('message.message Error: ${message.message}');
                sendErrorResponseMessage();
              }),
        ],
      ),
    );
  }

  void sendSuccessResponseMessage() {
    ShowMessage().showNotification("Your Payment was Successful!");
  }

  void sendErrorResponseMessage() {
    ShowMessage().showNotification("Your Payment was not Successful!");
  }

  void processPayment(remitaRefCode, remitaAmount) async {
    var remitaData = {
      'amount': remitaAmount,
      'ref_code': remitaRefCode,
    };
    var res = await Network().authData(remitaData, '/payments');
    var body = json.decode(res.body);
    if (body['success']?.isNotEmpty == true) {
      Get.to(Home());
      sendSuccessResponseMessage();
    } else {
      Get.to(Home());

      ShowMessage().showNotification("There was a problem with Payment!");
    }
  }
}
