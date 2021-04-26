import 'package:niia_mis_app/widgets/ShowMessage.dart';
import 'package:niia_mis_app/widgets/awabuttoncustom.dart';
import 'package:niia_mis_app/widgets/size_config.dart';
import 'package:niia_mis_app/network_utils/api.dart';
import 'package:niia_mis_app/widgets/nav-drawer.dart';
import 'package:flutter/material.dart';
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
  List<String> membership = <String>['Full', 'Corporate', 'Life'];
  String _selectedMembership;
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
      ShowMessage().showNotification(
          "This is the final Member Type. You cannot Upgrade!");
    }
  }

  getPaymentProcessingDetails() async {
    final res = await Network().getData('/upgrade');
    var result = json.decode(res.body);
    print(result);
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
    ShowMessage().showNotification(
        "You should be Approved to Upgrade Membership before you make payment");
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
            color: Colors.blue[700],
            fontWeight: FontWeight.w700),
        controller: _fullnameController,
        decoration: InputDecoration(
          labelText: 'Full name',
          labelStyle: TextStyle(
            color: Colors.blue[700],
            fontSize: 2.86 * SizeConfig.safeBlockVertical,
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
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.safeBlockHorizontal, 0,
          15 * SizeConfig.safeBlockHorizontal, 0),
      child: DropdownButton<String>(
        hint: Text(
          'Select Membership',
          style: TextStyle(
              fontSize: 2.8 * SizeConfig.safeBlockVertical,
              color: Colors.blue[700],
              fontWeight: FontWeight.w700),
        ),
        isExpanded: true,
        value: _membershipsubscription,
        items: membership.map((String members) {
          return DropdownMenuItem<String>(
            value: members,
            child: new Text(members),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            //_membership = membership.indexOf(value);
            _membershipsubscription = value;

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
      padding: EdgeInsets.fromLTRB(15 * SizeConfig.safeBlockHorizontal, 0,
          15 * SizeConfig.safeBlockHorizontal, 0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(
            fontSize: 2.8 * SizeConfig.safeBlockVertical,
            color: Colors.blue[700],
            fontWeight: FontWeight.w700),
        controller: _amountController,
        decoration: InputDecoration(
          labelText: 'Total',
          labelStyle: TextStyle(
            color: Colors.blue[700],
            fontSize: 2.86 * SizeConfig.safeBlockVertical,
          ),
          filled: true,
          fillColor: Colors.grey[300],
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
            color: Colors.blue[700],
            fontWeight: FontWeight.w700),
        controller: _emailnameController,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.blue[700],
            fontSize: 2.86 * SizeConfig.safeBlockVertical,
          ),
          filled: true,
          fillColor: Colors.grey[300],
        ),
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
            color: Colors.blue[700],
            fontWeight: FontWeight.w700),
        controller: _phonenoController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          labelStyle: TextStyle(
            color: Colors.blue[700],
            fontSize: 2.86 * SizeConfig.safeBlockVertical,
          ),
          filled: true,
          fillColor: Colors.grey[300],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Upgrade Membership',
            style: TextStyle(
              color: Colors.white,
              fontSize: 3.5 * SizeConfig.safeBlockVertical,
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
                    _buildMembership(),
                    SizedBox(height: 2 * SizeConfig.safeBlockVertical),
                    _buildAmount(),
                    SizedBox(height: 2 * SizeConfig.safeBlockVertical),
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
                              )),
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
