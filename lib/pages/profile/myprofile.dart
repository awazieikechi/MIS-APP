import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niia_mis_app/widgets/size_config.dart';
import 'package:niia_mis_app/pages/profile/editprofile.dart';
import 'package:niia_mis_app/pages/payments/transactions.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var userImage;
  String userFirstName;
  String userLastName;
  String userEmail;
  String userPhoneNo;
  String userPosition;
  String userHomeAddress;
  String userOrganisationAddress;
  String userMembership;
  String userCity;
  String userMemberId;
  String userName;
  String userdate_of_birth;
  String message = 'false';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          FutureBuilder(
            future: getUserImage(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.connectionState);
              print(snapshot.data);
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                print(snapshot.data);
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text("Waiting...");
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    userImage = snapshot.data;
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: NetworkImage(
                                'https://mis.michelleandanthony.net/storage/uploads/${snapshot.data}'),
                            fit: BoxFit.cover,
                            colorFilter: new ColorFilter.mode(
                                Colors.blue[800].withOpacity(1.0),
                                BlendMode.multiply),
                          )),
                        ),
                      ],
                    );
                  default:
                    break;
                }
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                  'There was an error',
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder(
                future: getUserImage(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.connectionState);
                  print(snapshot.data);
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("Waiting...");
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        return CircleAvatar(
                            radius: 10 * SizeConfig.safeBlockVertical,
                            backgroundColor: Colors.cyan[300],
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://mis.michelleandanthony.net/storage/uploads/${snapshot.data}'),
                              radius: 8.57 * SizeConfig.safeBlockVertical,
                            ));
                      default:
                        break;
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'There was an error',
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
              SizedBox(
                height: 2.14 * SizeConfig.safeBlockVertical,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    11 * SizeConfig.safeBlockHorizontal,
                    0 * SizeConfig.safeBlockVertical,
                    8 * SizeConfig.safeBlockHorizontal,
                    11 * SizeConfig.safeBlockVertical),
                child: RaisedButton(
                    child: Text('Edit Profile Picture',
                        style: TextStyle(
                          fontSize: 3 * SizeConfig.safeBlockVertical,
                          color: Colors.blue[900],
                        )),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    padding: EdgeInsets.fromLTRB(
                        0 * SizeConfig.safeBlockHorizontal,
                        2 * SizeConfig.safeBlockVertical,
                        0 * SizeConfig.safeBlockHorizontal,
                        2 * SizeConfig.safeBlockVertical),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile()));
                    }),
              ),
              SizedBox(
                height: 2 * SizeConfig.safeBlockVertical,
              ),
              FutureBuilder(
                future: getFullName(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.connectionState);
                  print(snapshot.data);
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("Waiting...");
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        return Center(
                          child: Text(
                            '${snapshot.data}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 5 * SizeConfig.safeBlockVertical,
                              fontFamily: 'Bebas Nue',
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
                      'There was an error',
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
              SizedBox(
                height: 2 * SizeConfig.safeBlockVertical,
              ),
              FutureBuilder(
                future: getUserEmail(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.connectionState);
                  print(snapshot.data);
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("Waiting...");
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        return Center(
                          child: Text(
                            '${snapshot.data}',
                            style: TextStyle(
                              color: Colors.cyan,
                              fontSize: 3 * SizeConfig.safeBlockVertical,
                              fontFamily: 'Bebas Nue',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      default:
                        break;
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'There was an error',
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
              SizedBox(
                height: 2 * SizeConfig.safeBlockVertical,
              ),
              FutureBuilder(
                future: getUserName(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.connectionState);
                  print(snapshot.data);
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("Waiting...");
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        return Center(
                          child: Text(
                            '${snapshot.data}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 3 * SizeConfig.safeBlockVertical,
                              fontFamily: 'Bebas Nue',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      default:
                        break;
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'There was an error',
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
              SizedBox(
                height: 3.14 * SizeConfig.safeBlockVertical,
              ),
              FutureBuilder(
                future: getUserHomeAddress(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.connectionState);
                  print(snapshot.data);
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("Waiting...");
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        return Center(
                          child: Text(
                            '${snapshot.data}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 3 * SizeConfig.safeBlockVertical,
                              fontFamily: 'Bebas Nue',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      default:
                        break;
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'There was an error',
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
              SizedBox(
                height: 6.14 * SizeConfig.safeBlockVertical,
              ),
              FutureBuilder(
                future: getUserDateBirth(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.connectionState);
                  print(snapshot.data);
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("Waiting...");
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        return Center(
                          child: Text(
                            '${snapshot.data}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 3 * SizeConfig.safeBlockVertical,
                              fontFamily: 'Bebas Nue',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      default:
                        break;
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'There was an error',
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
              FutureBuilder(
                future: getUserMemberId(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.connectionState);
                  print(snapshot.data);
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("Waiting...");
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        return Center(
                          child: Text(
                            '${snapshot.data}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 3 * SizeConfig.safeBlockVertical,
                              fontFamily: 'Bebas Nue',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      default:
                        break;
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'There was an error',
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
              SizedBox(
                height: 4 * SizeConfig.safeBlockVertical,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          8 * SizeConfig.safeBlockHorizontal,
                          0 * SizeConfig.safeBlockVertical,
                          8 * SizeConfig.safeBlockHorizontal,
                          0 * SizeConfig.safeBlockVertical),
                      child: RaisedButton(
                        child: Text('Edit Profile',
                            style: TextStyle(
                              fontSize: 3 * SizeConfig.safeBlockVertical,
                              color: Colors.white,
                            )),
                        color: Colors.cyan[300],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        padding: EdgeInsets.fromLTRB(
                            0 * SizeConfig.safeBlockHorizontal,
                            2 * SizeConfig.safeBlockVertical,
                            0 * SizeConfig.safeBlockHorizontal,
                            2 * SizeConfig.safeBlockVertical),
                        onPressed: () {
                          Get.to(EditProfile(message: message));
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 0.3 * SizeConfig.safeBlockHorizontal),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          6 * SizeConfig.safeBlockHorizontal,
                          0 * SizeConfig.safeBlockVertical,
                          6 * SizeConfig.safeBlockHorizontal,
                          0 * SizeConfig.safeBlockVertical), //10 for example
                      child: RaisedButton(
                        child: Text('Transactions',
                            style: TextStyle(
                              fontSize: 3 * SizeConfig.safeBlockVertical,
                              color: Colors.white,
                            )),
                        color: Colors.cyan[300],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        padding: EdgeInsets.fromLTRB(
                            2 * SizeConfig.safeBlockHorizontal,
                            2 * SizeConfig.safeBlockVertical,
                            0 * SizeConfig.safeBlockHorizontal,
                            2 * SizeConfig.safeBlockVertical),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserPaymentTransaction()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }

  getUserImage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    userImage = localStorage.getString('userImage');
    return userImage;
  }

  getFullName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    userFirstName = localStorage.getString('userFirstName');
    userLastName = localStorage.getString('userLastName');
    return userFirstName + " " + userLastName;
  }

  getUserEmail() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    userEmail = localStorage.getString('userEmail');
    return userEmail;
  }

  getUserHomeAddress() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    userHomeAddress = localStorage.getString('userHomeAddress');
    return userHomeAddress;
  }

  getUserDateBirth() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    userdate_of_birth = localStorage.getString('userBirthDate');

    return userdate_of_birth;
  }

  getUserMemberId() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    userMemberId = localStorage.getString('userMemberId');

    return userMemberId;
  }

  getUserName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    userName = localStorage.getString('userName');

    return userName;
  }
}
