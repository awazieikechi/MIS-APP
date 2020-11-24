import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:niia_mis_app/pages/register.dart';
import 'package:niia_mis_app/pages/home.dart';
import 'dart:convert';
import 'package:niia_mis_app/network_utils/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:niia_mis_app/widgets/size_config.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var _username;
  var _password;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _showMsg() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Password and username is wrong',
          style: TextStyle(fontSize: 2.5 * SizeConfig.textMultiplier)),
      duration: Duration(seconds: 6),
      backgroundColor: Colors.blue[900],
    ));
    // Scafford.of(context).showSnackbar(snackBar);
  }

  Widget _buildUserName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Username',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
        ),
        hintText: 'Username',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Username is required';
        }
      },
      onSaved: (String value) {
        _username = value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            SizeConfig().init(constraints, orientation);
            return Scaffold(
                key: _scaffoldKey,
                body: SafeArea(
                    child: Stack(
                  children: [
                    Container(
                      //10 for example
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(
                            'assets/images/pexels-athena-2582937.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(
                            Colors.purple[900].withOpacity(1.0),
                            BlendMode.multiply),
                      )),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 0.7 * SizeConfig.heightMultiplier),
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/niialogo12.jpg'),
                            radius: 2.86 * SizeConfig.heightMultiplier,
                          ),
                          SizedBox(height: 4.28 * SizeConfig.heightMultiplier),
                          Text(
                            'Welcome to',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 3 * SizeConfig.textMultiplier,
                              fontFamily: 'Typographica',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 1.43 * SizeConfig.heightMultiplier),
                          Text(
                            'NIIA',
                            style: TextStyle(
                              color: Colors.cyan[300],
                              fontSize: 6.29 * SizeConfig.textMultiplier,
                              fontFamily: 'Typographica',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.0,
                            ),
                          ),
                          SizedBox(height: 2.14 * SizeConfig.heightMultiplier),
                          Text(
                            'Powered by',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 2.71 * SizeConfig.textMultiplier,
                              fontFamily: 'Typographica',
                            ),
                          ),
                          Text(
                            'Nigerian Institute of International Affairs',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 2.71 * SizeConfig.textMultiplier,
                              fontFamily: 'Typographica',
                            ),
                          ),
                          SizedBox(height: 1.43 * SizeConfig.heightMultiplier),
                          Padding(
                              padding: EdgeInsets.all(
                                  2.86 * SizeConfig.heightMultiplier),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      _buildUserName(),
                                      SizedBox(
                                          height: 4.29 *
                                              SizeConfig.heightMultiplier),
                                      _buildPassword(),
                                      SizedBox(
                                          height: 2.86 *
                                              SizeConfig.heightMultiplier),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              child: RaisedButton.icon(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(2.57 *
                                                          SizeConfig
                                                              .heightMultiplier),
                                                ),
                                                onPressed: () {
                                                  if (!_formKey.currentState
                                                      .validate()) {
                                                    return;
                                                  }
                                                  _formKey.currentState.save();
                                                  _login();
                                                },
                                                color: Colors.black,
                                                icon: SvgPicture.asset(
                                                    "assets/images/loginpx.svg"),
                                                label: Text('Login',
                                                    style: TextStyle(
                                                      fontSize: 2.71 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      color: Colors.white,
                                                    )),
                                                padding: EdgeInsets.fromLTRB(
                                                    5 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    2.86 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    5 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    2.86 *
                                                        SizeConfig
                                                            .heightMultiplier),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: 2.5 *
                                                  SizeConfig.widthMultiplier),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              //10 for example
                                              child: RaisedButton.icon(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(2.57 *
                                                          SizeConfig
                                                              .heightMultiplier),
                                                ),
                                                onPressed: () {},
                                                color: Colors.black,
                                                icon: Icon(
                                                  Icons.fingerprint,
                                                  color: Colors.white,
                                                  size: 4.29 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                ),
                                                label: Text(""),
                                                padding: EdgeInsets.fromLTRB(
                                                    5 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    2.86 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    5 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    2.86 *
                                                        SizeConfig
                                                            .heightMultiplier),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      3.75 * SizeConfig.widthMultiplier,
                                      1.43 * SizeConfig.heightMultiplier,
                                      3.75 * SizeConfig.widthMultiplier,
                                      1.43 * SizeConfig.heightMultiplier),
                                  child: RaisedButton.icon(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          2.57 * SizeConfig.heightMultiplier),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Register()),
                                      );
                                    },
                                    color: Colors.blue[600],
                                    icon: SvgPicture.asset(
                                        "assets/images/contact_mail.svg"),
                                    label: Text('Register',
                                        style: TextStyle(
                                          fontSize:
                                              2.71 * SizeConfig.textMultiplier,
                                          color: Colors.white,
                                        )),
                                    padding: EdgeInsets.fromLTRB(
                                        5 * SizeConfig.widthMultiplier,
                                        2.14 * SizeConfig.heightMultiplier,
                                        5 * SizeConfig.widthMultiplier,
                                        2.14 * SizeConfig.heightMultiplier),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ],
                )));
          },
        );
      },
    );
  }

  void _login() async {
    var data = {
      'username': _username,
      'password': _password,
    };

    Response res = await Network().authData(data, '/login');

    var result = json.decode(res.body);
    print(result);
    if (result['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(result['token']));
      localStorage.setString('userStatus', '0');
      Get.to(Home());
    } else {
      _showMsg();
    }
  }
}
