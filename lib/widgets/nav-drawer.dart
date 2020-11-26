import 'package:flutter/material.dart';
import 'package:niia_mis_app/pages/payments/transactions.dart';
import 'package:niia_mis_app/pages/profile/myprofile.dart';
import 'package:niia_mis_app/pages/home.dart';

import 'package:niia_mis_app/pages/changepassword.dart';
import 'package:niia_mis_app/pages/news.dart';
import 'package:niia_mis_app/pages/onlinebooks.dart';
import 'package:niia_mis_app/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:get/get.dart';
import 'package:niia_mis_app/widgets/size_config.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  var firstname;
  var lastname;
  var username;

  void initState() {
    super.initState();
  }

  Future<String> getFullName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    firstname = localStorage.getString('userFirstName');
    lastname = localStorage.getString('userLastName');
    return firstname + " " + lastname;
  }

  Future<String> getUserName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    username = localStorage.getString('userName');

    return username;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          FutureBuilder(
            future: getFullName(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.connectionState);
              print(snapshot.data);
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text("Waiting...");
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return UserAccountsDrawerHeader(
                      accountName: Text(snapshot.data,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 3 * SizeConfig.safeBlockVertical,
                            fontWeight: FontWeight.w700,
                          )),
                      currentAccountPicture: FutureBuilder(
                        future: _loadImage(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
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
                                    radius: 14 * SizeConfig.safeBlockVertical,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          'https://mis.michelleandanthony.net/storage/uploads/${snapshot.data}'),
                                      radius:
                                          8.57 * SizeConfig.safeBlockVertical,
                                    ));
                              default:
                                break;
                            }
                          }
                        },
                      ),
                      accountEmail: FutureBuilder(
                        future: getUserName(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Text("Waiting...");
                              case ConnectionState.waiting:
                                return CircularProgressIndicator();
                              case ConnectionState.active:
                              case ConnectionState.done:
                                return Text(snapshot.data,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          3 * SizeConfig.safeBlockVertical,
                                      fontWeight: FontWeight.w700,
                                    ));
                              default:
                                break;
                            }
                          }
                        },
                      ),
                    );

                  default:
                    break;
                }
              } else if (snapshot.hasError) {
                return Padding(
                    padding: EdgeInsets.fromLTRB(130.0, 0, 150.0, 0),
                    child: Text(
                      'Could not get Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 2.57 * SizeConfig.safeBlockVertical,
                        fontFamily: 'Typographica',
                        fontWeight: FontWeight.w700,
                      ),
                    ));
              }
            },
          ),
          ListTile(
            leading:
                Icon(Icons.input, size: 2.39 * SizeConfig.safeBlockVertical),
            title: Text(
              'Home',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 2.39 * SizeConfig.safeBlockVertical),
            ),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user,
                size: 2.39 * SizeConfig.safeBlockVertical),
            title: Text(
              'Profile',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 2.39 * SizeConfig.safeBlockVertical),
            ),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.new_releases_sharp,
                size: 2.39 * SizeConfig.safeBlockVertical),
            title: Text(
              'News',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 2.39 * SizeConfig.safeBlockVertical),
            ),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => News()),
              )
            },
          ),
          ListTile(
            leading:
                Icon(Icons.payment, size: 2.39 * SizeConfig.safeBlockVertical),
            title: Text(
              'Transactions',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 2.39 * SizeConfig.safeBlockVertical),
            ),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserPaymentTransaction()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.book_online,
                size: 2.39 * SizeConfig.safeBlockVertical),
            title: Text(
              'Books',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 2.39 * SizeConfig.safeBlockVertical),
            ),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OnlineBooks()),
              )
            },
          ),
          ListTile(
            leading:
                Icon(Icons.settings, size: 2.39 * SizeConfig.safeBlockVertical),
            title: Text(
              'Change Password',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 2.39 * SizeConfig.safeBlockVertical),
            ),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => changePassword()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail_rounded,
                size: 2.39 * SizeConfig.safeBlockVertical),
            title: Text(
              'Contact Us',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 2.39 * SizeConfig.safeBlockVertical),
            ),
            onTap: () => {_launchURL()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app,
                size: 2.39 * SizeConfig.safeBlockVertical),
            title: Text(
              'Logout',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 2.39 * SizeConfig.safeBlockVertical),
            ),
            onTap: () => {logout()},
          ),
        ],
      ),
    );
  }

  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
    localStorage.setString('userStatus', '0');
    Get.to(Login());
  }

  _launchURL() async {
    const url = 'mailto:support@niia.gov.ng?subject=Enquiries';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<String> _loadImage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String Value = localStorage.getString('userImage');
    return Value;
  }
}
