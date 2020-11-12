import 'package:niia_mis_app/widgets/size_config.dart';
import 'package:niia_mis_app/network_utils/paymentprocessingapi.dart';
import 'package:niia_mis_app/network_utils/api.dart';
import 'package:niia_mis_app/widgets/nav-drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:niia_mis_app/pages/home.dart';
import 'package:get/get.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:uuid/uuid.dart';

class UserPayment extends StatefulWidget {
  String message;
  UserPayment({this.message});

  @override
  _UserPaymentState createState() => _UserPaymentState(message: message);
}

class _UserPaymentState extends State<UserPayment> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String message;
  _UserPaymentState({this.message});
  var _processingFeeAmount;
  var _amount;
  var _total;
  var _fullname;
  var _email;
  var _phoneno;
  var _firstname;
  var _lastname;

  TextEditingController _processingFeeController;
  TextEditingController _fullnameController;
  TextEditingController _amountController;
  TextEditingController _emailnameController;
  TextEditingController _phonenoController;

  void initState() {
    checkMessage(message);
    getPaymentProcessingDetails();
    getUserFullname();
    print(_amount);
    super.initState();
  }

  getPaymentProcessingDetails() async {
    final res = await Network().getData('/payments');
    PaymentProcessingApi payments = paymentProcessingApiFromJson(res.body);

    setState(() {
      _processingFeeAmount = payments.processingFeeAmount;
      _amount = payments.amount;
      _total = payments.total;
      if (_amount > 10000) {
        _processingFeeController = new TextEditingController(
            text: 'N ' + _processingFeeAmount.toString());
      } else {
        _processingFeeController = null;
      }

      _amountController =
          new TextEditingController(text: 'N ' + _amount.toString());
    });
  }

  Future<Null> getUserFullname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _firstname = prefs.getString('userFirstName');
    _lastname = prefs.getString('userLastName');
    _email = prefs.getString('userEmail');
    _phoneno = prefs.getString('userPhoneNo');
    _fullname = _firstname + " " + _lastname;
    setState(() {
      _fullnameController = new TextEditingController(text: _fullname);
      _emailnameController = new TextEditingController(text: _email);
      _phonenoController = new TextEditingController(text: _phoneno);
    });
  }

  Widget _buildFullName() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.widthMultiplier, 0,
          15 * SizeConfig.widthMultiplier, 0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(
            fontSize: 2.8 * SizeConfig.textMultiplier,
            color: Colors.white,
            fontWeight: FontWeight.w700),
        controller: _fullnameController,
        decoration: InputDecoration(
          labelText: 'Full name',
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 2.86 * SizeConfig.textMultiplier,
          ),
          filled: true,
          fillColor: Colors.cyan[300],
        ),
        onSaved: (String value) {
          _fullname = value;
        },
      ),
    );
  }

  Widget _buildProcessingFee() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.widthMultiplier, 0,
          15 * SizeConfig.widthMultiplier, 0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(
            fontSize: 2.8 * SizeConfig.textMultiplier,
            color: Colors.white,
            fontWeight: FontWeight.w700),
        controller: _processingFeeController,
        decoration: InputDecoration(
          labelText: 'Processing fee',
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 2.86 * SizeConfig.textMultiplier,
          ),
          filled: true,
          fillColor: Colors.cyan[300],
        ),
        onSaved: (String value) {
          _processingFeeAmount = value;
        },
      ),
    );
  }

  Widget _buildAmount() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.widthMultiplier, 0,
          15 * SizeConfig.widthMultiplier, 0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(
            fontSize: 2.8 * SizeConfig.textMultiplier,
            color: Colors.white,
            fontWeight: FontWeight.w700),
        controller: _amountController,
        decoration: InputDecoration(
          labelText: 'Amount',
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 2.86 * SizeConfig.textMultiplier,
          ),
          filled: true,
          fillColor: Colors.cyan[300],
        ),
        onSaved: (String value) {
          _processingFeeAmount = value;
        },
      ),
    );
  }

  Widget _buildEmail() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.widthMultiplier, 0,
          15 * SizeConfig.widthMultiplier, 0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(
            fontSize: 2.8 * SizeConfig.textMultiplier,
            color: Colors.white,
            fontWeight: FontWeight.w700),
        controller: _emailnameController,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 2.86 * SizeConfig.textMultiplier,
          ),
          filled: true,
          fillColor: Colors.cyan[300],
        ),
        onSaved: (String value) {
          _email = value;
        },
      ),
    );
  }

  Widget _buildPhoneNumber() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.widthMultiplier, 0,
          15 * SizeConfig.widthMultiplier, 0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(
            fontSize: 2.8 * SizeConfig.textMultiplier,
            color: Colors.white,
            fontWeight: FontWeight.w700),
        controller: _phonenoController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 2.86 * SizeConfig.textMultiplier,
          ),
          filled: true,
          fillColor: Colors.cyan[300],
        ),
        onSaved: (String value) {
          _phoneno = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            SizeConfig().init(constraints, orientation);
            return Scaffold(
              drawer: NavDrawer(),
              appBar: AppBar(
                title: Text('Payment Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 3.5 * SizeConfig.textMultiplier,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    )),
                centerTitle: true,
                backgroundColor: Colors.cyan[300],
                iconTheme: new IconThemeData(color: Colors.white),
              ),
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.cyan[300]),
                  ),
                  SizedBox(height: 5 * SizeConfig.heightMultiplier),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: new Border.all(
                            color: Colors.black,
                            width: 0.25 * SizeConfig.widthMultiplier,
                            style: BorderStyle.solid),
                        borderRadius: new BorderRadius.vertical(
                          top: new Radius.circular(
                              8.5 * SizeConfig.heightMultiplier),
                        ),
                      ),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4 * SizeConfig.heightMultiplier),
                            _buildFullName(),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier),
                            _buildEmail(),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier),
                            _buildPhoneNumber(),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier),
                            _buildAmount(),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier),
                            _processingFeeController != null
                                ? _buildProcessingFee()
                                : SizedBox(),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier),
                            Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          20 * SizeConfig.widthMultiplier,
                                          0,
                                          0 * SizeConfig.widthMultiplier,
                                          0),
                                      child: Text('Total',
                                          style: TextStyle(
                                            fontSize: 2.71 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: 0.5 * SizeConfig.widthMultiplier),
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0 * SizeConfig.widthMultiplier,
                                          0,
                                          20 * SizeConfig.widthMultiplier,
                                          0),
                                      child: Text('N $_total',
                                          style: TextStyle(
                                            fontSize: 3.71 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.cyan[300],
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6 * SizeConfig.heightMultiplier),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        5 * SizeConfig.widthMultiplier,
                                        0,
                                        5 * SizeConfig.widthMultiplier,
                                        0),
                                    child: RaisedButton(
                                      onPressed: () {
                                        var uuid = Uuid();
                                        var myStringrefCode = uuid.v1();
                                        var refCode = myStringrefCode
                                            .replaceAll(RegExp('-'), '');
                                        var data = {
                                          'firstname': _firstname,
                                          'lastname': _lastname,
                                          'email': _email,
                                          'amount': _total,
                                          'phonenumber': _phoneno,
                                          'refCode': refCode,
                                        };

                                        Get.to(RemitaCustomGateway(data: data));
                                      },
                                      color: Colors.red,
                                      child: Text('Make Payment',
                                          style: TextStyle(
                                            fontSize: 2.71 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.white,
                                          )),
                                      padding: EdgeInsets.fromLTRB(
                                          3 * SizeConfig.widthMultiplier,
                                          1.86 * SizeConfig.heightMultiplier,
                                          3 * SizeConfig.widthMultiplier,
                                          1.86 * SizeConfig.heightMultiplier),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: 0.5 * SizeConfig.widthMultiplier),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        5 * SizeConfig.widthMultiplier,
                                        0,
                                        5 * SizeConfig.widthMultiplier,
                                        0),
                                    child: RaisedButton(
                                      onPressed: () {
                                        cancelPage();
                                      },
                                      color: Colors.grey[800],
                                      child: Text("Cancel",
                                          style: TextStyle(
                                            fontSize: 2.71 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.white,
                                          )),
                                      padding: EdgeInsets.fromLTRB(
                                          3 * SizeConfig.widthMultiplier,
                                          1.86 * SizeConfig.heightMultiplier,
                                          3 * SizeConfig.widthMultiplier,
                                          1.86 * SizeConfig.heightMultiplier),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void checkMessage(message) {
    if (message == 'true') {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Flushbar(
            messageText: Text(
                "To Continue using our services. Please make payment today!",
                style: TextStyle(
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                    color: Colors.white)),
            icon: Icon(
              Icons.info_outline,
              size: 4 * SizeConfig.heightMultiplier,
              color: Colors.blue[300],
            ),
            duration: Duration(seconds: 8),
            leftBarIndicatorColor: Colors.blue[300],
            backgroundColor: Colors.black)
          ..show(context);
      });
    }
  }

  void cancelPage() {
    Get.to(Home());
  }
}

class RemitaCustomGateway extends StatefulWidget {
  final data;

  RemitaCustomGateway({this.data});

  @override
  _RemitaCustomGatewayState createState() =>
      _RemitaCustomGatewayState(data: data);
}

class _RemitaCustomGatewayState extends State<RemitaCustomGateway> {
  final data;

  _RemitaCustomGatewayState({this.data});

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
      function makePayment() {
        var paymentEngine = RmPaymentEngine.init({
          key:
            "QzAwMDAxOTUwNjl8NDMyNTkxNjl8ZTg0MjI2MDg4MjU0NzA2NTY2MTYwNGU1NjNiMjUzYjk4ZDQwZjljZGFiMTVmYTljMDUwMGQ0MDg2MjIyYjEyNTA1ZTE2MTMxNmE3ZjM1OTZmYmJkOTE2MTRiY2NmZTY5NTM4MGQ2MDBlZGJlZmM2ODc2YTc2M2M4MjgyZmFjODc=",
          email: "$data.email",
          currency: "NGN",
          firstName: "$data.firstname",
          lastName: "$data.lastname",
          customerId: "$data.email",
          phoneNumber: "$data.phonenumber",
          transactionId: "$data.refCode",
          narration: "GIFMIS Revenue Reference Number 1000184417",
          amount: "1000",

          onSuccess: function (response) {
            console.log(JSON.stringify(response));
            var onSuccess;
            onSuccess.postMessage(response);
          },
          onError: function (response) {
            console.log(JSON.stringify(response));
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
              name: 'OnSuccess',
              onMessageReceived: (JavascriptMessage message) {
                print(message.message);
              }),
          JavascriptChannel(
              name: 'onClose',
              onMessageReceived: (JavascriptMessage message) {
                print(message.message);
              }),
          JavascriptChannel(
              name: 'OnError',
              onMessageReceived: (JavascriptMessage message) {
                print(message.message);
              }),
        ],
      ),
    );
  }
}
