import 'dart:async';
import 'package:niia_mis_app/pages/onlinebooks.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:niia_mis_app/pages/login.dart';
import 'package:niia_mis_app/pages/news.dart';
import 'package:niia_mis_app/loading.dart';
import 'package:niia_mis_app/pages/profile/myprofile.dart';
import 'package:niia_mis_app/pages/payments/payments.dart';
import 'package:niia_mis_app/pages/payments/upgradepayments.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:niia_mis_app/widgets/nav-drawer.dart';
import 'package:niia_mis_app/widgets/size_config.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    checkuserstatus();
    super.initState();
  }

  Future checkuserstatus() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userstatus = localStorage.getString('userStatus');
    if (userstatus == '0') {
      Loading().getUserStatus();
    }
  }

  Future<String> _loadImage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String Value = localStorage.getString('userImage');
    return Value;
  }

  Future<String> userFirstName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String Value = localStorage.getString('userFirstName');
    return Value;
  }

  Future<String> _userMembership() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String Value = localStorage.getString('userMembership');
    return Value;
  }

  loadInitialData() {
    return 'assets/images/niiabanner.jpg';
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
                title: Text('DASHBOARD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 3.5 * SizeConfig.textMultiplier,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    )),
                centerTitle: true,
                backgroundColor: Colors.blue[800],
              ),
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/homebackground.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Colors.blue[800].withOpacity(1.0),
                          BlendMode.multiply),
                    )),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 0.71 * SizeConfig.heightMultiplier),
                      Center(
                        child: FutureBuilder(
                          future: _loadImage(),
                          initialData: loadInitialData(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return CircleAvatar(
                                  radius: 10 * SizeConfig.heightMultiplier,
                                  backgroundColor: Colors.black,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/niialogo12.jpg'),
                                  ));
                            } else if (snapshot.hasData) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/niialogo12.jpg'),
                                  );
                                case ConnectionState.waiting:
                                  return CircularProgressIndicator();
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  return CircleAvatar(
                                      radius: 10 * SizeConfig.heightMultiplier,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            'https://mis.michelleandanthony.net/storage/uploads/${snapshot.data}'),
                                        radius:
                                            8.57 * SizeConfig.heightMultiplier,
                                      ));
                                default:
                                  break;
                              }
                            } else if (snapshot.hasError) {
                              return CircleAvatar(
                                  radius: 10 * SizeConfig.heightMultiplier,
                                  backgroundColor: Colors.black,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/niialogo12.jpg'),
                                  ));
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 0.71 * SizeConfig.heightMultiplier),
                      FutureBuilder(
                        future: userFirstName(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text(
                                'Welcome!',
                                style: TextStyle(
                                  color: Colors.cyan[300],
                                  fontSize: 4 * SizeConfig.textMultiplier,
                                  fontFamily: 'Typographica',
                                ),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Text("Welcome!");
                              case ConnectionState.waiting:
                                return CircularProgressIndicator();
                              case ConnectionState.active:
                              case ConnectionState.done:
                                return Center(
                                  child: Text(
                                    'Welcome! ${snapshot.data}',
                                    style: TextStyle(
                                      color: Colors.cyan[300],
                                      fontSize: 4 * SizeConfig.textMultiplier,
                                      fontFamily: 'Typographica',
                                    ),
                                  ),
                                );
                              default:
                                break;
                            }
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Welcome!',
                                style: TextStyle(
                                  color: Colors.cyan[300],
                                  fontSize: 4 * SizeConfig.textMultiplier,
                                  fontFamily: 'Typographica',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      FutureBuilder(
                        future: _userMembership(),
                        initialData: Center(
                          child: Text(
                            'Membership',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 2.57 * SizeConfig.textMultiplier,
                              fontFamily: 'Typographica',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text(
                                'Membership',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 2.57 * SizeConfig.textMultiplier,
                                  fontFamily: 'Typographica',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Center(
                                  child: Text(
                                    'Membership',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          2.57 * SizeConfig.textMultiplier,
                                      fontFamily: 'Typographica',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                );
                              case ConnectionState.waiting:
                                return CircularProgressIndicator();
                              case ConnectionState.active:
                              case ConnectionState.done:
                                return Center(
                                  child: Text(
                                    '${snapshot.data} Membership',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          2.57 * SizeConfig.textMultiplier,
                                      fontFamily: 'Typographica',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                );
                              default:
                                break;
                            }
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Membership',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 2.57 * SizeConfig.textMultiplier,
                                  fontFamily: 'Typographica',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 1.43 * SizeConfig.heightMultiplier),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            7.5 * SizeConfig.widthMultiplier,
                            1.43 * SizeConfig.heightMultiplier,
                            7.5 * SizeConfig.widthMultiplier,
                            1.43 * SizeConfig.heightMultiplier),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  2.5 * SizeConfig.widthMultiplier,
                                  0.86 * SizeConfig.heightMultiplier,
                                  2.5 * SizeConfig.widthMultiplier,
                                  0.86 * SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: new Border.all(
                                      color: Colors.black,
                                      width: 0.1 * SizeConfig.widthMultiplier,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(
                                      1.43 * SizeConfig.heightMultiplier),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        spreadRadius:
                                            0.25 * SizeConfig.widthMultiplier)
                                  ]),
                              child: GestureDetector(
                                onTap: () {
                                  print('working');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OnlineBooks()),
                                  );
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/class-57px.svg',
                                      color: Colors.cyan[300],
                                    ),
                                    Text('Online',
                                        style: TextStyle(
                                            fontSize: 2.14 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue[900],
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                    Text('BookShop',
                                        style: TextStyle(
                                            fontSize: 2.14 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue[900],
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 5.9 * SizeConfig.widthMultiplier),
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  2.5 * SizeConfig.widthMultiplier,
                                  0.86 * SizeConfig.heightMultiplier,
                                  2.5 * SizeConfig.widthMultiplier,
                                  0.86 * SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: new Border.all(
                                      color: Colors.black,
                                      width: 0.1 * SizeConfig.widthMultiplier,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(
                                      1.43 * SizeConfig.heightMultiplier),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        spreadRadius:
                                            0.25 * SizeConfig.textMultiplier)
                                  ]),
                              child: GestureDetector(
                                onTap: () {
                                  print('working');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserPayment()),
                                  );
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/assignment_turned_in-57px.svg',
                                      color: Colors.cyan[300],
                                    ),
                                    Text('Membership',
                                        style: TextStyle(
                                            fontSize: 2.14 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue[900],
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                    Text('Subscription',
                                        style: TextStyle(
                                            fontSize: 2.14 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue[900],
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 4.25 * SizeConfig.widthMultiplier),
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  2.5 * SizeConfig.widthMultiplier,
                                  0.86 * SizeConfig.heightMultiplier,
                                  2.5 * SizeConfig.widthMultiplier,
                                  0.86 * SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: new Border.all(
                                      color: Colors.black,
                                      width: 0.1 * SizeConfig.widthMultiplier,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(
                                      1.42 * SizeConfig.heightMultiplier),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        spreadRadius:
                                            0.25 * SizeConfig.widthMultiplier)
                                  ]),
                              child: GestureDetector(
                                onTap: () {
                                  print('working');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UpgradePayment()),
                                  );
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/trending_up-57px.svg',
                                      color: Colors.cyan[300],
                                    ),
                                    Text('Upgrade',
                                        style: TextStyle(
                                            fontSize: 2.14 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue[900],
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                    Text('Membership',
                                        style: TextStyle(
                                            fontSize: 2.14 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue[900],
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            7.5 * SizeConfig.widthMultiplier,
                            1.43 * SizeConfig.heightMultiplier,
                            7.5 * SizeConfig.widthMultiplier,
                            1.43 * SizeConfig.heightMultiplier),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  2.5 * SizeConfig.widthMultiplier,
                                  2.14 * SizeConfig.heightMultiplier,
                                  2.5 * SizeConfig.widthMultiplier,
                                  2.14 * SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: new Border.all(
                                      color: Colors.black,
                                      width: 0.1 * SizeConfig.heightMultiplier,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(
                                      1.43 * SizeConfig.heightMultiplier),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        spreadRadius:
                                            0.25 * SizeConfig.heightMultiplier)
                                  ]),
                              child: GestureDetector(
                                onTap: () {
                                  print('working');
                                  _launchURL('http://hallbooking.niia.gov.ng/');
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/apartment-57px.svg',
                                      color: Colors.cyan[300],
                                    ),
                                    Text('Hire a Hall',
                                        style: TextStyle(
                                            fontSize: 2.14 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue[900],
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 5.25 * SizeConfig.heightMultiplier),
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  2.5 * SizeConfig.widthMultiplier,
                                  2.14 * SizeConfig.heightMultiplier,
                                  2.5 * SizeConfig.widthMultiplier,
                                  2.14 * SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: new Border.all(
                                      color: Colors.black,
                                      width: 0.1 * SizeConfig.heightMultiplier,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(
                                      1.43 * SizeConfig.heightMultiplier),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        spreadRadius:
                                            0.25 * SizeConfig.heightMultiplier)
                                  ]),
                              child: GestureDetector(
                                onTap: () {
                                  print('working');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Profile()),
                                  );
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/account_box-57px.svg',
                                      color: Colors.cyan[300],
                                    ),
                                    Text('My Profile',
                                        style: TextStyle(
                                            fontSize: 2.14 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue[900],
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 5 * SizeConfig.textMultiplier),
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  2.5 * SizeConfig.widthMultiplier,
                                  2.14 * SizeConfig.heightMultiplier,
                                  2.5 * SizeConfig.widthMultiplier,
                                  2.14 * SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: new Border.all(
                                      color: Colors.black,
                                      width: 0.1 * SizeConfig.heightMultiplier,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(
                                      1.43 * SizeConfig.heightMultiplier),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black, spreadRadius: 1.0)
                                  ]),
                              child: GestureDetector(
                                onTap: () {
                                  print('working');
                                  _launchURL(
                                      'mailto:support@niia.gov.ng?subject=Enquiries');
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/contact_mail-57px.svg',
                                      color: Colors.cyan[300],
                                    ),
                                    Text('Contact Us',
                                        style: TextStyle(
                                            fontSize: 2.14 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue[900],
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            7.25 * SizeConfig.widthMultiplier,
                            1.43 * SizeConfig.heightMultiplier,
                            7.25 * SizeConfig.widthMultiplier,
                            1.43 * SizeConfig.heightMultiplier),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  3.5 * SizeConfig.widthMultiplier,
                                  0.86 * SizeConfig.heightMultiplier,
                                  3.5 * SizeConfig.widthMultiplier,
                                  0.86 * SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: new Border.all(
                                      color: Colors.black,
                                      width: 0.1 * SizeConfig.heightMultiplier,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(
                                      1.43 * SizeConfig.heightMultiplier),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black, spreadRadius: 1.0)
                                  ]),
                              child: GestureDetector(
                                onTap: () {
                                  print('working');
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/feedback-57px.svg',
                                      color: Colors.cyan[300],
                                    ),
                                    Text('Compliants',
                                        style: TextStyle(
                                            fontSize: 2.14 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue[900],
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 6.9 * SizeConfig.widthMultiplier),
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  2.5 * SizeConfig.widthMultiplier,
                                  1.86 * SizeConfig.heightMultiplier,
                                  2.5 * SizeConfig.widthMultiplier,
                                  1.86 * SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: new Border.all(
                                      color: Colors.black,
                                      width: 0.1 * SizeConfig.heightMultiplier,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(
                                      1.43 * SizeConfig.heightMultiplier),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black, spreadRadius: 1.0)
                                  ]),
                              child: GestureDetector(
                                onTap: () {
                                  print('working');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => News()),
                                  );
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/assignment-57px.svg',
                                      color: Colors.cyan[300],
                                    ),
                                    Text('News',
                                        style: TextStyle(
                                            fontSize: 2.14 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue[900],
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 6 * SizeConfig.widthMultiplier,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  2.5 * SizeConfig.widthMultiplier,
                                  1.86 * SizeConfig.heightMultiplier,
                                  2.5 * SizeConfig.widthMultiplier,
                                  1.86 * SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: new Border.all(
                                      color: Colors.black,
                                      width: 0.1 * SizeConfig.heightMultiplier,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(
                                      1.43 * SizeConfig.heightMultiplier),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black, spreadRadius: 1.0)
                                  ]),
                              child: GestureDetector(
                                onTap: () {
                                  print('working');
                                  logout();
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/input-57px.svg',
                                      color: Colors.cyan[300],
                                    ),
                                    Text('LogOut',
                                        style: TextStyle(
                                            fontSize: 2.14 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue[900],
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
    localStorage.setString('userStatus', '0');
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }
}
