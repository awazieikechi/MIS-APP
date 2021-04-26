import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:niia_mis_app/network_utils/api.dart';
import 'package:niia_mis_app/pages/home.dart';
import 'package:niia_mis_app/widgets/ShowMessage.dart';
import 'package:niia_mis_app/widgets/awabuttonbuttoncustomicon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niia_mis_app/widgets/size_config.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  var gender = <String>['Male', 'Female'];
  var _gendervalue;
  int _gender;
  int _membership;
  var membership = <String>['Associate', 'Full', 'Corporate', 'Life'];
  var _membershipsubscription;
  var _username;
  var _password;
  var _confirmpassword;
  var _email;
  var _firstname;
  var _lastname;
  var _homeaddress;
  var _phonenumber;
  DateTime _dateofbirth = DateTime.now();
  var _city;
  var _state;
  var _country;
  var _organisation;
  var _position;
  var _oraganisationaddress;

  Widget _buildFirstName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'First name',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'First name',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'First name is required';
        }
      },
      onSaved: (String value) {
        _firstname = value;
      },
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Last Name',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'Last name',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Last name is required';
        }
      },
      onSaved: (String value) {
        _lastname = value;
      },
    );
  }

  Widget _buildUserName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Username',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
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

  Widget _buildEmail() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'email',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'email',
      ),
      validator: (value) =>
          EmailValidator.validate(value) ? null : "Please enter a valid email",
      onSaved: (String value) {
        _email = value;
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
      },
      onSaved: (String value) {
        _confirmpassword = value;
      },
    );
  }

  Widget _buildHomeAdress() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Home Address',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'Home Address',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Home Address is required';
        }
      },
      onSaved: (String value) {
        _homeaddress = value;
      },
    );
  }

  Widget _buildGender() {
    return DropdownButton<String>(
      hint: Text('Select Gender'),
      isExpanded: true,
      value: _gender == null ? null : gender[_gender],
      items: gender.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _gender = gender.indexOf(value);
          _gendervalue = gender[_gender];
        });
      },
    );
  }

  Widget _buildMembership() {
    return DropdownButton<String>(
      hint: Text('Select Membership'),
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
        });
      },
    );
  }

  Widget _buildCity() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'City',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'City',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'City is required';
        }
      },
      onSaved: (String value) {
        _city = value;
      },
    );
  }

  Widget _buildState() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'State',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'State',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'State is required';
        }
      },
      onSaved: (String value) {
        _state = value;
      },
    );
  }

  Widget _buildCountry() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Country',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'Country',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Country is required';
        }
      },
      onSaved: (String value) {
        _country = value;
      },
    );
  }

  final TextEditingController _controller = new TextEditingController();
  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _controller.text = new DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  Widget _buildDateofBirth() {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'Date of Birth',
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        _chooseDate(context, _controller.text);
      },
    );
  }

  Widget _buildContactNumber() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'Phone Number',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Phone Number is required';
        }
      },
      onSaved: (String value) {
        _phonenumber = value;
      },
    );
  }

  Widget _buildOrganisation() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Organisation',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'Organisation',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Organisation is required';
        }
      },
      onSaved: (String value) {
        _organisation = value;
      },
    );
  }

  Widget _buildOrganisationAddress() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Organisation Address',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'Organisation Address',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Organisation Address is required';
        }
      },
      onSaved: (String value) {
        _oraganisationaddress = value;
      },
    );
  }

  Widget _buildPosition() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Position',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: 'Position',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Position is required';
        }
      },
      onSaved: (String value) {
        _position = value;
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
                  'Register',
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
                  _buildFirstName(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildLastName(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildUserName(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildEmail(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildPassword(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildConfirmPassword(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildHomeAdress(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildGender(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildContactNumber(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildDateofBirth(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildCity(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildState(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildCountry(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildOrganisation(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildPosition(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildOrganisationAddress(),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  _buildMembership(),
                  Text(
                    'Please check the official website to learn more about the different levels of Membership',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 3.7 * SizeConfig.safeBlockHorizontal,
                      fontFamily: 'Typographica',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3 * SizeConfig.safeBlockVertical),
                  Container(
                    child: AwaButtonCustomIcon(
                      title: 'Register',
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
                        await _register();
                      },
                      icon: Icon(
                        Icons.file_download,
                        color: Colors.white,
                      ),
                      color: Colors.blue[900],
                      textColor: Colors.white,
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

  _register() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'firstname': _firstname,
      'lastname': _lastname,
      'email': _email,
      'password': _password,
      'password_confirmation': _confirmpassword,
      'membership_subscription': _membershipsubscription,
      'phonenumber': _phonenumber,
      'date_of_birth': _dateofbirth.toString().substring(0, 10),
      'position': _position,
      'organisation': _organisation,
      'organisation_address': _oraganisationaddress,
      'city': _city,
      'state': _state,
      'country': _country,
      'username': _username,
      'Gender': _gendervalue,
      'home_address': _homeaddress,
    };

    var res = await Network().authData(data, '/register');
    var body = json.decode(res.body);
    var errorResponse = body['error'];
    print(data);
    print(body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('userFirstName', json.encode(body['name']));
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      ShowMessage().showNotification(errorResponse.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }
}
