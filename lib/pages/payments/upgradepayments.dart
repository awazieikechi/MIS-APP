import 'package:niia_mis_app/widgets/size_config.dart';
import 'package:niia_mis_app/network_utils/api.dart';
import 'package:niia_mis_app/widgets/nav-drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niia_mis_app/pages/payments/payments.dart';
import 'package:flutter/cupertino.dart';
import 'package:niia_mis_app/pages/home.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:niia_mis_app/pages/profile/editprofile.dart';
import 'package:niia_mis_app/pages/payments/remitacustomgateway.dart';
import 'package:uuid/uuid.dart';
import 'package:niia_mis_app/widgets/remitadata.dart';

class UpgradePayment extends StatefulWidget {
  @override
  _UpgradePaymentState createState() => _UpgradePaymentState();
}

class _UpgradePaymentState extends State<UpgradePayment> {
  final String message = 'true';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _membership;
  var membership = <String>['Full', 'Corporate', 'Life'];
  var _membershipsubscription;
  var _remainingFullAmount;
  var _remainingCorporateAmount;
  var _remainingLifeAmount;
  var _total;

  var _fullname;
  var _email;
  var _phoneno;
  var _firstname;
  var _lastname;

  TextEditingController _remainingFullAmountController;
  TextEditingController _remainingCorporateAmountController;
  TextEditingController _remainingLifeAmountController;
  TextEditingController _fullnameController;
  TextEditingController _amountController;
  TextEditingController _emailnameController;
  TextEditingController _phonenoController;

  void initState() {
    checkUserMembershipStatus();
    getPaymentProcessingDetails();
    getUserFullname();
    sendNotificationUser();
    super.initState();
  }

  Future checkUserMembershipStatus() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var membershipstatus = localStorage.getString('userMembership');
    if (membershipstatus == 'Corporate') {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Flushbar(
            messageText: Text(
                "This is the final Member Type. You cannot Upgrade!",
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

  getPaymentProcessingDetails() async {
    final res = await Network().getData('/upgrade');
    var result = json.decode(res.body);

    if (result['paymentfailed'] != null) {
      Get.to(UserPayment(message: message));
    } else if (result['profilefailed'] != null) {
      Get.to(EditProfile(message: message));
    } else {
      setState(() {
        _remainingFullAmount = result['remainingFullAmount'];
        _remainingCorporateAmount = result['remainingCorporateAmount'];
        _remainingLifeAmount = result['remainingLifeAmount'];
      });
    }
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

  sendNotificationUser() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Flushbar(
          messageText: Text(
              "You should be Approved to Upgrade Membership before you make payment",
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

  Widget _buildFullName() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.widthMultiplier, 0,
          15 * SizeConfig.widthMultiplier, 0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(
            fontSize: 2.8 * SizeConfig.textMultiplier,
            color: Colors.blue[700],
            fontWeight: FontWeight.w700),
        controller: _fullnameController,
        decoration: InputDecoration(
          labelText: 'Full name',
          labelStyle: TextStyle(
            color: Colors.blue[700],
            fontSize: 2.86 * SizeConfig.textMultiplier,
          ),
          filled: true,
          fillColor: Colors.grey[300],
        ),
        onSaved: (String value) {
          _fullname = value;
        },
      ),
    );
  }

  Widget _buildMembership() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.widthMultiplier, 0,
          15 * SizeConfig.widthMultiplier, 0),
      child: DropdownButton<String>(
        hint: Text(
          'Select Membership',
          style: TextStyle(
              fontSize: 2.8 * SizeConfig.textMultiplier,
              color: Colors.blue[700],
              fontWeight: FontWeight.w700),
        ),
        isExpanded: true,
        value: _membership == null ? null : membership[_membership],
        items: membership.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _membership = membership.indexOf(value);
            _membershipsubscription = membership[_membership];

            if (_membershipsubscription == "Full") {
              _amountController = new TextEditingController(
                  text: 'N ' + _remainingFullAmount.toString());
              _total = _remainingFullAmount;
            } else if (_membershipsubscription == "Corporate") {
              _amountController = new TextEditingController(
                  text: 'N ' + _remainingCorporateAmount.toString());
              _total = _remainingCorporateAmount;
            } else {
              _amountController = new TextEditingController(
                  text: 'N ' + _remainingLifeAmount.toString());
              _total = _remainingLifeAmount;
            }
          });
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
            color: Colors.blue[700],
            fontWeight: FontWeight.w700),
        controller: _amountController,
        decoration: InputDecoration(
          labelText: 'Total',
          labelStyle: TextStyle(
            color: Colors.blue[700],
            fontSize: 2.86 * SizeConfig.textMultiplier,
          ),
          filled: true,
          fillColor: Colors.grey[300],
        ),
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
            color: Colors.blue[700],
            fontWeight: FontWeight.w700),
        controller: _emailnameController,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.blue[700],
            fontSize: 2.86 * SizeConfig.textMultiplier,
          ),
          filled: true,
          fillColor: Colors.grey[300],
        ),
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
            color: Colors.blue[700],
            fontWeight: FontWeight.w700),
        controller: _phonenoController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          labelStyle: TextStyle(
            color: Colors.blue[700],
            fontSize: 2.86 * SizeConfig.textMultiplier,
          ),
          filled: true,
          fillColor: Colors.grey[300],
        ),
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
                title: Text('Upgrade Membership',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 3.5 * SizeConfig.textMultiplier,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    )),
                centerTitle: true,
                backgroundColor: Colors.blue[700],
                iconTheme: new IconThemeData(color: Colors.white),
              ),
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.blue[700]),
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
                            _buildMembership(),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier),
                            _buildAmount(),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier),
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
                                        var tokenGenerate = Uuid();
                                        var refCode = tokenGenerate.v4();
                                        var data = RemitaData(
                                            firstname: _firstname,
                                            lastname: _lastname,
                                            email: _email,
                                            phonenumber: _phoneno,
                                            refCode: refCode,
                                            total: _total);

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
