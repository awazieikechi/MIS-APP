import 'package:flutter/material.dart';
import 'package:niia_mis_app/helpers/hallbookingroute.dart';
import 'package:niia_mis_app/helpers/booksapproute.dart';
import 'package:niia_mis_app/pages/register.dart';
import 'package:niia_mis_app/pages/home.dart';
import 'dart:convert';
import 'package:niia_mis_app/network_utils/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:niia_mis_app/widgets/ShowMessage.dart';
import 'package:niia_mis_app/styles.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:niia_mis_app/widgets/size_config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool drawerCanOpen = true;
  var _username;
  var _password;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildUserName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Username',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.safeBlockVertical),
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
          borderRadius: BorderRadius.circular(2 * SizeConfig.safeBlockVertical),
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

  Widget _buildharmburgerMenu() {
    return Positioned(
      top: 7.4 * SizeConfig.safeBlockVertical,
      left: 5 * SizeConfig.safeBlockVertical,
      child: GestureDetector(
        onTap: () {
          if (drawerCanOpen) {
            _scaffoldKey.currentState.openDrawer();
          } else {}
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(6.5 * SizeConfig.safeBlockHorizontal),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ]),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 6.5 * SizeConfig.safeBlockHorizontal,
            child: Icon(
              (drawerCanOpen) ? Icons.menu : Icons.arrow_back,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(children: [
            ListTile(
              leading: Icon(OMIcons.hotel, color: Colors.red),
              title: Text(
                'Hall booking',
                style: kDrawerItemStyle,
              ),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HallBookingRoute()),
                )
              },
            ),
            ListTile(
              leading: Icon(OMIcons.book, color: Colors.red),
              title: Text(
                'Bookshop',
                style: kDrawerItemStyle,
              ),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookAppRoute()),
                )
              },
            ),
          ]),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 0.7 * SizeConfig.safeBlockHorizontal),
              //10 for example
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/pexels-athena-2582937.jpg'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.purple[900].withOpacity(1.0), BlendMode.multiply),
              )),
            ),
            Column(children: [
              SizedBox(height: 0.7 * SizeConfig.safeBlockVertical),
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/niialogo12.jpg'),
                radius: 2.86 * SizeConfig.safeBlockVertical,
              ),
              SizedBox(height: 4.28 * SizeConfig.safeBlockVertical),
              Text(
                'Welcome to',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 3 * SizeConfig.safeBlockVertical,
                  fontFamily: 'Typographica',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 1.43 * SizeConfig.safeBlockVertical),
              Text(
                'NIIA',
                style: TextStyle(
                  color: Colors.cyan[300],
                  fontSize: 6.29 * SizeConfig.safeBlockVertical,
                  fontFamily: 'Typographica',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 2.14 * SizeConfig.safeBlockVertical),
              Text(
                'Powered by',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 2.71 * SizeConfig.safeBlockVertical,
                  fontFamily: 'Typographica',
                ),
              ),
              Text(
                'Nigerian Institute of International Affairs',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 2.71 * SizeConfig.safeBlockVertical,
                  fontFamily: 'Typographica',
                ),
              ),
              SizedBox(height: 1.43 * SizeConfig.safeBlockVertical),
              Padding(
                  padding: EdgeInsets.all(2.86 * SizeConfig.safeBlockVertical),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildUserName(),
                          SizedBox(height: 4.29 * SizeConfig.safeBlockVertical),
                          _buildPassword(),
                          SizedBox(height: 2.86 * SizeConfig.safeBlockVertical),
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: TextButton.icon(
                                      style: ButtonStyle(
                                          padding:
                                              MaterialStateProperty.all<EdgeInsets>(
                                                  EdgeInsets.all(4 *
                                                      SizeConfig
                                                          .safeBlockHorizontal)),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4.5 * SizeConfig.safeBlockHorizontal),
                                                  side: BorderSide(color: Colors.black)))),
                                      onPressed: () async {
                                        if (!_formKey.currentState.validate()) {
                                          return;
                                        }
                                        _formKey.currentState.save();
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            });
                                        await _login();
                                      },
                                      icon: SvgPicture.asset(
                                          "assets/images/loginpx.svg"),
                                      label: Text('Login',
                                          style: TextStyle(
                                            fontSize: 2.71 *
                                                SizeConfig.safeBlockVertical,
                                            color: Colors.white,
                                          )),
                                    ),
                                  )),
                              SizedBox(
                                  width: 2.5 * SizeConfig.safeBlockHorizontal),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  //10 for example
                                  child: TextButton.icon(
                                    style: ButtonStyle(
                                        padding:
                                            MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.all(4 *
                                                    SizeConfig
                                                        .safeBlockHorizontal)),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4.5 * SizeConfig.safeBlockHorizontal),
                                                side: BorderSide(color: Colors.black)))),
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.fingerprint,
                                      color: Colors.white,
                                      size: 4.29 * SizeConfig.safeBlockVertical,
                                    ),
                                    label: Text(""),
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
                          3.75 * SizeConfig.safeBlockHorizontal,
                          1.43 * SizeConfig.safeBlockVertical,
                          3.75 * SizeConfig.safeBlockHorizontal,
                          1.43 * SizeConfig.safeBlockVertical),
                      child: TextButton.icon(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(
                                    4 * SizeConfig.safeBlockHorizontal)),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        4.5 * SizeConfig.safeBlockHorizontal),
                                    side: BorderSide(color: Colors.blue)))),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        icon:
                            SvgPicture.asset("assets/images/contact_mail.svg"),
                        label: Text('Register',
                            style: TextStyle(
                              fontSize: 2.71 * SizeConfig.safeBlockVertical,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
            _buildharmburgerMenu(),
          ],
        )));
  }

  _login() async {
    var data = {
      'username': _username,
      'password': _password,
    };
    print(data);
    var res = await Network().authData(data, '/login');
    print(res);
    var result = json.decode(res.body);
    print(result);
    if (result['success'] != 'false') {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(result['token']));
      localStorage.setString('userStatus', '0');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      ShowMessage().showNotification('Password or username is wrong');
    }
  }
}
