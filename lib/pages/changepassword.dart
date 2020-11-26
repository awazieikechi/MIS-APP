import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'dart:convert';
import 'package:niia_mis_app/network_utils/api.dart';
import 'package:niia_mis_app/widgets/size_config.dart';
import 'package:flutter/scheduler.dart';
import 'package:niia_mis_app/pages/home.dart';
import 'package:get/get.dart';

class changePassword extends StatefulWidget {
  changePassword({Key key}) : super(key: key);

  @override
  _changePasswordState createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  final _formKey = GlobalKey<FormState>();

  var _oldpassword;
  var _password;
  var _confirmpassword;

  Widget _buildOldPassword() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Current Password',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'Password',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }
      },
      onSaved: (String value) {
        _oldpassword = value;
      },
    );
  }

  Widget _buildNewPassword() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'New Password',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'Password',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  Widget _buildConfirmPassword() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'Password',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }
        if (_password != _oldpassword) {
          return 'Password does not match';
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Colors.grey[100],
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.all(6.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/niialogo12.jpg'),
                  radius: 7.0 * SizeConfig.safeBlockVertical,
                ),
                Text(
                  'Password Reset',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 5.7 * SizeConfig.safeBlockHorizontal,
                    fontFamily: 'Typographica',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildOldPassword(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildNewPassword(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildConfirmPassword(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  Container(
                    child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            1.57 * SizeConfig.safeBlockVertical),
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        _formKey.currentState.save();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        await _changepassword();
                      },
                      color: Colors.blue[900],
                      icon: Icon(
                        Icons.file_download,
                        color: Colors.white,
                      ),
                      label: Text('Change Password',
                          style: TextStyle(
                            fontSize: 2.65 * SizeConfig.safeBlockHorizontal,
                            color: Colors.white,
                          )),
                      padding: EdgeInsets.fromLTRB(
                          5 * SizeConfig.safeBlockHorizontal,
                          2.86 * SizeConfig.safeBlockVertical,
                          5 * SizeConfig.safeBlockHorizontal,
                          2.86 * SizeConfig.safeBlockVertical),
                    ),
                  ),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                ],
              ),
            ),
          ),
        ]),
      )),
    );
  }

  _changepassword() async {
    var data = {
      'current-password': _oldpassword,
      'new-password': _password,
      'new-password_confirmation': _password,
    };
    print(data);

    var res = await Network().authData(data, '/changepassword');
    var body = json.decode(res.body);

    if (body['success']?.isNotEmpty == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Flushbar(
            messageText: Text("Password changed successfully !",
                style: TextStyle(
                    fontSize: 2.5 * SizeConfig.safeBlockHorizontal,
                    color: Colors.white)),
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.blue[300],
            ),
            duration: Duration(seconds: 8),
            leftBarIndicatorColor: Colors.blue[300],
            backgroundColor: Colors.black)
          ..show(context);
      });
      Get.to(Home());
    } else if (!body) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Flushbar(
            messageText: Text("Password could not be updated!",
                style: TextStyle(
                    fontSize: 2.5 * SizeConfig.safeBlockHorizontal,
                    color: Colors.white)),
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.blue[300],
            ),
            duration: Duration(seconds: 8),
            leftBarIndicatorColor: Colors.blue[300],
            backgroundColor: Colors.black)
          ..show(context);
      });
    }
  }
}
