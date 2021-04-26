import 'package:niia_mis_app/widgets/awabuttoncustom.dart';
import 'package:niia_mis_app/widgets/size_config.dart';
import 'package:niia_mis_app/network_utils/paymentprocessingapi.dart';
import 'package:niia_mis_app/network_utils/api.dart';
import 'package:niia_mis_app/widgets/nav-drawer.dart';
import 'package:flutter/material.dart';
import 'package:niia_mis_app/widgets/ShowMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:niia_mis_app/pages/home.dart';
import 'package:niia_mis_app/pages/payments/remitacustomgateway.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:niia_mis_app/widgets/remitadata.dart';

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
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.safeBlockHorizontal, 0,
          15 * SizeConfig.safeBlockHorizontal, 0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(
            fontSize: 2.8 * SizeConfig.safeBlockVertical,
            color: Colors.white,
            fontWeight: FontWeight.w700),
        controller: _fullnameController,
        decoration: InputDecoration(
          labelText: 'Full name',
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 2.86 * SizeConfig.safeBlockVertical,
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
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.safeBlockHorizontal, 0,
          15 * SizeConfig.safeBlockHorizontal, 0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(
            fontSize: 2.8 * SizeConfig.safeBlockVertical,
            color: Colors.white,
            fontWeight: FontWeight.w700),
        controller: _processingFeeController,
        decoration: InputDecoration(
          labelText: 'Processing fee',
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 2.86 * SizeConfig.safeBlockVertical,
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
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.safeBlockHorizontal, 0,
          15 * SizeConfig.safeBlockHorizontal, 0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(
            fontSize: 2.8 * SizeConfig.safeBlockVertical,
            color: Colors.white,
            fontWeight: FontWeight.w700),
        controller: _amountController,
        decoration: InputDecoration(
          labelText: 'Amount',
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 2.86 * SizeConfig.safeBlockVertical,
          ),
          filled: true,
          fillColor: Colors.cyan[300],
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.safeBlockHorizontal, 0,
          15 * SizeConfig.safeBlockHorizontal, 0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(
            fontSize: 2.8 * SizeConfig.safeBlockVertical,
            color: Colors.white,
            fontWeight: FontWeight.w700),
        controller: _emailnameController,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 2.86 * SizeConfig.safeBlockVertical,
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
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.safeBlockHorizontal, 0,
          15 * SizeConfig.safeBlockHorizontal, 0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(
            fontSize: 2.8 * SizeConfig.safeBlockVertical,
            color: Colors.white,
            fontWeight: FontWeight.w700),
        controller: _phonenoController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 2.86 * SizeConfig.safeBlockVertical,
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
    SizeConfig().init(context);
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Payment Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 3.5 * SizeConfig.safeBlockVertical,
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
          SizedBox(height: 5 * SizeConfig.safeBlockVertical),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: new Border.all(
                    color: Colors.black,
                    width: 0.25 * SizeConfig.safeBlockHorizontal,
                    style: BorderStyle.solid),
                borderRadius: new BorderRadius.vertical(
                  top: new Radius.circular(8.5 * SizeConfig.safeBlockVertical),
                ),
              ),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4 * SizeConfig.safeBlockVertical),
                    _buildFullName(),
                    SizedBox(height: 2 * SizeConfig.safeBlockVertical),
                    _buildEmail(),
                    SizedBox(height: 2 * SizeConfig.safeBlockVertical),
                    _buildPhoneNumber(),
                    SizedBox(height: 2 * SizeConfig.safeBlockVertical),
                    _buildAmount(),
                    SizedBox(height: 2 * SizeConfig.safeBlockVertical),
                    _processingFeeController != null
                        ? _buildProcessingFee()
                        : SizedBox(),
                    SizedBox(height: 2 * SizeConfig.safeBlockVertical),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                  20 * SizeConfig.safeBlockHorizontal,
                                  0,
                                  0 * SizeConfig.safeBlockHorizontal,
                                  0),
                              child: Text('Total',
                                  style: TextStyle(
                                    fontSize:
                                        2.71 * SizeConfig.safeBlockVertical,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(width: 0.5 * SizeConfig.safeBlockHorizontal),
                        Expanded(
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                  0 * SizeConfig.safeBlockHorizontal,
                                  0,
                                  20 * SizeConfig.safeBlockHorizontal,
                                  0),
                              child: Text('N $_total',
                                  style: TextStyle(
                                    fontSize:
                                        3.71 * SizeConfig.safeBlockVertical,
                                    color: Colors.cyan[300],
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6 * SizeConfig.safeBlockVertical),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                5 * SizeConfig.safeBlockHorizontal,
                                0,
                                5 * SizeConfig.safeBlockHorizontal,
                                0),
                            child: AwaButtonCustom(
                              title: 'Make Payment',
                              onPressed: () {
                                var tokenGenerate = Uuid();
                                var refCode = tokenGenerate.v4();
                                var data = RemitaData(
                                    firstname: _firstname.toString(),
                                    lastname: _lastname,
                                    email: _email,
                                    phonenumber: _phoneno,
                                    refCode: refCode,
                                    total: _total);

                                Get.to(RemitaCustomGateway(data: data));
                              },
                              color: Colors.red,
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 0.5 * SizeConfig.safeBlockHorizontal),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                5 * SizeConfig.safeBlockHorizontal,
                                0,
                                5 * SizeConfig.safeBlockHorizontal,
                                0),
                            child: AwaButtonCustom(
                              title: 'Cancel',
                              onPressed: () {
                                cancelPage();
                              },
                              color: Colors.grey[800],
                              textColor: Colors.white,
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
  }

  void checkMessage(message) {
    if (message == 'true') {
      ShowMessage().showNotification(
          "To Continue using our services. Please make payment today!");
    }
  }

  void cancelPage() {
    Get.to(Home());
  }
}
