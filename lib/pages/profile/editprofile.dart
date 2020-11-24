import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:niia_mis_app/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niia_mis_app/widgets/size_config.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:niia_mis_app/network_utils/api.dart';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class EditProfile extends StatefulWidget {
  String message;
  EditProfile({this.message});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String message;
  _EditProfileState({this.message});

// Data Variable For Upload Documents
  var token;
  File _imagePassport;
  File _imageFirstDegree;
  File _imageMasterDegree;
  File _imageYouthService;
  var imageData;

  final picker = ImagePicker();
  Dio dio = new Dio();
  Response response;
  FormData formdata;
  String uploadurl = "https://mis.michelleandanthony.net/api/upload";

  // Data Variable For Update Profile

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var gender = <String>['Male', 'Female'];
  var _gendervalue;
  int _gender;
  var _email;
  var _firstname;
  var _lastname;
  var _homeaddress;
  var _phonenumber;
  var _dateofbirth;
  var _dateofbirthvalue;
  var _city;
  var _state;
  var _country;
  var _organisation;
  var _position;
  var _organisationaddress;
  var _membershipSubscription;

  TextEditingController _dateofbirthController;
  TextEditingController _firstnameController;
  TextEditingController _lastnameController;
  TextEditingController _gendervalueController;
  TextEditingController _membershipsubscriptionController;
  TextEditingController _emailController;
  TextEditingController _homeaddressController;
  TextEditingController _phonenumberController;
  TextEditingController _cityController;
  TextEditingController _stateController;
  TextEditingController _positionController;
  TextEditingController _organisationaddressController;
  TextEditingController _countryController;
  TextEditingController _organisationController;
  var _initialdateofbirthController;

  void initState() {
    checkMessage(message);
    getSharedPrefs();
    super.initState();
  }

  /* Get Saved Data for Form*/
  getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _firstname = prefs.getString('userFirstName');
    _lastname = prefs.getString('userLastName');
    _email = prefs.getString('userEmail');
    _phonenumber = prefs.getString('userPhoneNo');
    _position = prefs.getString(
      'userPosition',
    );
    _homeaddress = prefs.getString('userHomeAddress');
    _organisationaddress = prefs.getString('userOrganisationAddress');
    _city = prefs.getString('userCity');
    _dateofbirth = prefs.getString('userBirthDate');
    var _gendervaluestate = prefs.getString('userGender');
    _country = prefs.getString('userCountry');
    _state = prefs.getString('userState');

    _organisation = prefs.getString('userOrganisation');
    _membershipSubscription = prefs.getString('userMembership');
    var tokenstate = jsonDecode(prefs.getString('token'));

    setState(() {
      _firstnameController = new TextEditingController(text: _firstname);
      _lastnameController = new TextEditingController(text: _lastname);
      //_gendervalueController = new TextEditingController(text: _gendervalue);
      _membershipsubscriptionController =
          new TextEditingController(text: _membershipSubscription);
      _emailController = new TextEditingController(text: _email);
      _homeaddressController = new TextEditingController(text: _homeaddress);
      _phonenumberController = new TextEditingController(text: _phonenumber);

      _dateofbirthController = new TextEditingController(text: _dateofbirth);
      _initialdateofbirthController = _dateofbirth;
      _cityController = new TextEditingController(text: _city);
      _stateController = new TextEditingController(text: _state);
      _positionController = new TextEditingController(text: _position);
      _organisationaddressController =
          new TextEditingController(text: _organisationaddress);
      _countryController = new TextEditingController(text: _country);
      _organisationController = new TextEditingController(text: _organisation);
      token = tokenstate;
      print(_gendervaluestate);

      _gendervalue = _gendervaluestate;
    });
  }

  void checkMessage(message) {
    if (message == 'true') {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Flushbar(
            messageText: Text(
                "You need to upload your documents in your profile before you make payment",
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

  Widget _buildFirstName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _firstnameController,
      decoration: InputDecoration(
        labelText: 'First name',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
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
      controller: _lastnameController,
      decoration: InputDecoration(
        labelText: 'Last Name',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
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

  Widget _buildEmail() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'email',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
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

  Widget _buildHomeAdress() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _homeaddressController,
      decoration: InputDecoration(
        labelText: 'Home Address',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
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
    print(_gendervalue);
    return DropdownButton<String>(
      hint: Text('Select Gender'),
      isExpanded: true,
      value: _gendervalue != null ? _gendervalue : gender[_gender],
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

  Widget _buildCity() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _cityController,
      decoration: InputDecoration(
        labelText: 'City',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
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
      controller: _stateController,
      decoration: InputDecoration(
        labelText: 'State',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
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
      controller: _countryController,
      decoration: InputDecoration(
        labelText: 'Country',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
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

  // Set up Date Picker

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
      _dateofbirthController.text = new DateFormat.yMd().format(result);
      _dateofbirthvalue = new DateFormat.yMd().format(result);
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
      controller: _dateofbirthController,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
        ),
        hintText: 'Date of Birth',
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        _chooseDate(context, _dateofbirthController.text);
      },
    );
  }

  Widget _buildContactNumber() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _phonenumberController,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
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
      controller: _organisationController,
      decoration: InputDecoration(
        labelText: 'Organisation',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
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
      controller: _organisationaddressController,
      decoration: InputDecoration(
        labelText: 'Organisation Address',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
        ),
        hintText: 'Organisation Address',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Organisation Address is required';
        }
      },
      onSaved: (String value) {
        _organisationaddress = value;
      },
    );
  }

  Widget _buildPosition() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _positionController,
      decoration: InputDecoration(
        labelText: 'Position',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2 * SizeConfig.heightMultiplier),
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

  Widget _updateProfile() {
    return Container(
      color: Colors.grey[100],
      child: ListView(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                _buildFirstName(),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                _buildLastName(),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                _buildEmail(),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                _buildHomeAdress(),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                _buildGender(),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                _buildContactNumber(),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                _buildDateofBirth(),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                _buildCity(),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                _buildState(),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                _buildCountry(),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                _buildOrganisation(),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                _buildPosition(),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                _buildOrganisationAddress(),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                Container(
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          1.57 * SizeConfig.heightMultiplier),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      _updateuser();
                    },
                    color: Colors.blue[900],
                    icon: Icon(
                      Icons.file_download,
                      color: Colors.white,
                    ),
                    label: Text('Update',
                        style: TextStyle(
                          fontSize: 3 * SizeConfig.textMultiplier,
                          color: Colors.white,
                        )),
                    padding: EdgeInsets.fromLTRB(
                        5 * SizeConfig.widthMultiplier,
                        2.86 * SizeConfig.heightMultiplier,
                        5 * SizeConfig.widthMultiplier,
                        2.86 * SizeConfig.heightMultiplier),
                  ),
                ),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget showPassport() {
    return Center(
      child: _imagePassport == null
          ? Text('No image selected.')
          : Image.file(_imagePassport),
    );
  }

  Future _pickImagePassportFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    Directory filePathImagePassport = await getApplicationDocumentsDirectory();
    final String _filePathImagePassport = filePathImagePassport.path;
    final fileName = path.basename(pickedFile.path);
    final File _imagePassportFile =
        await File(pickedFile.path).copy('$_filePathImagePassport/$fileName');

    setState(() {
      if (pickedFile != null) {
        _imagePassport = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget showFirstDegree() {
    return Center(
      child: _imageFirstDegree == null
          ? Text('No image selected.')
          : Image.file(_imageFirstDegree),
    );
  }

  Future _pickFirstDegreeFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    Directory filePathFirstDegree = await getApplicationDocumentsDirectory();
    final String _filePathFirstDegree = filePathFirstDegree.path;
    final fileName = path.basename(pickedFile.path);
    final File _imageFirstDegreeFile =
        await File(pickedFile.path).copy('$_filePathFirstDegree/$fileName');

    setState(() {
      if (pickedFile != null) {
        _imageFirstDegree = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget showMasterDegree() {
    return Center(
      child: _imageMasterDegree == null
          ? Text('No image selected.')
          : Image.file(_imageMasterDegree),
    );
  }

  Future _pickMasterDegreeFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    Directory filePathMasterDegree = await getApplicationDocumentsDirectory();
    final String _filePathMasterDegree = filePathMasterDegree.path;
    final fileName = path.basename(pickedFile.path);
    final File _imageMasterDegreeFile =
        await File(pickedFile.path).copy('$_filePathMasterDegree/$fileName');

    setState(() {
      if (pickedFile != null) {
        _imageMasterDegree = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget showYouthService() {
    return Center(
      child: _imageYouthService == null
          ? Text('No image selected.')
          : Image.file(_imageYouthService),
    );
  }

  Future _pickYouthServiceFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    Directory filePathYouthDegree = await getApplicationDocumentsDirectory();
    final String _filePathYouthDegree = filePathYouthDegree.path;
    final fileName = path.basename(pickedFile.path);
    final File _imageYouthServiceFile =
        await File(pickedFile.path).copy('$_filePathYouthDegree/$fileName');

    setState(() {
      if (pickedFile != null) {
        _imageYouthService = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _uploadDocument() {
    return ListView(children: [
      Container(
        padding: EdgeInsets.all(4.3 * SizeConfig.heightMultiplier),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlineButton(
              onPressed: _pickImagePassportFromGallery,
              borderSide: BorderSide(
                color: Colors.blue[900],
                width: 2.0,
              ),
              child: Text('Choose Passport',
                  style: TextStyle(
                    fontSize: 2.65 * SizeConfig.textMultiplier,
                  )),
            ),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier,
            ),
            showPassport(),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier,
            ),
            OutlineButton(
              onPressed: _pickFirstDegreeFromGallery,
              borderSide: BorderSide(
                color: Colors.blue[900],
                width: 2.0,
              ),
              child: Text('Choose First Degree Certificate',
                  style: TextStyle(
                    fontSize: 2.65 * SizeConfig.textMultiplier,
                  )),
            ),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier,
            ),
            showFirstDegree(),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier,
            ),
            OutlineButton(
              onPressed: _pickYouthServiceFromGallery,
              borderSide: BorderSide(
                color: Colors.blue[900],
                width: 2.0,
              ),
              child: Text('Choose Youth Service Certificate',
                  style: TextStyle(
                    fontSize: 2.65 * SizeConfig.textMultiplier,
                  )),
            ),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier,
            ),
            showYouthService(),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier,
            ),
            _membershipSubscription == "Associate"
                ? SizedBox()
                : OutlineButton(
                    onPressed: _pickMasterDegreeFromGallery,
                    borderSide: BorderSide(
                      color: Colors.blue[900],
                      width: 2.0,
                    ),
                    child: Text("Choose Master Degree Certificate ",
                        style: TextStyle(
                          fontSize: 2.65 * SizeConfig.textMultiplier,
                        )),
                  ),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier,
            ),
            _membershipSubscription == "Associate"
                ? SizedBox()
                : showMasterDegree(),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier,
            ),
            RaisedButton(
              onPressed: startUpload,
              color: Colors.blue[900],
              child: Text('Upload Documents',
                  style: TextStyle(
                    fontSize: 2.65 * SizeConfig.textMultiplier,
                    color: Colors.white,
                  )),
            ),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier,
            ),
            RaisedButton(
              onPressed: cancelUpload,
              color: Colors.red[900],
              child: Text('Cancel',
                  style: TextStyle(
                    fontSize: 2.65 * SizeConfig.textMultiplier,
                    color: Colors.white,
                  )),
            ),
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier,
            ),
          ],
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: TabBar(
                unselectedLabelColor: Colors.redAccent,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        7.2 * SizeConfig.heightMultiplier),
                    color: Colors.redAccent),
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              7.2 * SizeConfig.heightMultiplier),
                          border: Border.all(
                              color: Colors.redAccent,
                              width: 0.25 * SizeConfig.widthMultiplier)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("EDIT PROFILE"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              7.2 * SizeConfig.heightMultiplier),
                          border: Border.all(
                              color: Colors.redAccent,
                              width: 0.25 * SizeConfig.widthMultiplier)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("UPLOAD DOCUMENT"),
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            _updateProfile(),
            _uploadDocument(),
          ]),
        ));
  }

  void _updateuser() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'firstname': _firstname,
      'lastname': _lastname,
      'email': _email,
      'phonenumber': _phonenumber,
      'date_of_birth':
          _dateofbirthvalue == null ? _initialdateofbirthController : null,
      'position': _position,
      'organisation': _organisation,
      'organisation_address': _organisationaddress,
      'city': _city,
      'state': _state,
      'country': _country,
      'Gender': _gendervalue,
      'home_address': _homeaddress,
    };
    //print(data);

    var res = await Network().authData(data, '/profile/update');
    var body = json.decode(res.body);
    //print(body);

    if (body['success']?.isNotEmpty == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Flushbar(
            messageText: Text("Your Profile has been successfully updated!",
                style: TextStyle(
                    fontSize: 2.5 * SizeConfig.textMultiplier,
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
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Flushbar(
            messageText: Text("Profile could not be updated!",
                style: TextStyle(
                    fontSize: 2.5 * SizeConfig.textMultiplier,
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

  startUpload() async {
    FormData formdata = FormData.fromMap({
      "passport_image": _imagePassport.path == null
          ? ""
          : await MultipartFile.fromFile(_imagePassport.path,
              filename: path.basename(_imagePassport.path)
              //show only filename from path
              ),
      "first_degree_image": _imageFirstDegree.path == null
          ? ""
          : await MultipartFile.fromFile(_imageFirstDegree.path,
              filename: path.basename(_imageFirstDegree.path)
              //show only filename from path
              ),
      "youth_service_image": _imageYouthService.path == null
          ? ""
          : await MultipartFile.fromFile(_imageYouthService.path,
              filename: path.basename(_imageYouthService.path)
              //show only filename from path
              ),
      "master_degree_image": _imageMasterDegree == null
          ? ""
          : await MultipartFile.fromFile(_imageMasterDegree.path,
              filename: path.basename(_imageMasterDegree.path)
              //show only filename from path
              ),
    });

    try {
      response = await dio.post(
        uploadurl,
        data: formdata,
        options: Options(
          headers: {
            'Authorization': 'Bearer ' + token,
          },
        ),
      );
      //
    } on DioError catch (e) {
      print(e.toString());
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Flushbar(
            messageText: Text("There is an issue with uploading!!",
                style: TextStyle(
                    fontSize: 2.5 * SizeConfig.textMultiplier,
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
    print(response.statusCode);
    print(response.data.toString().substring(1, 8));

    var responseProfileMessage = response.data.toString().substring(1, 7);
    if (responseProfileMessage == "success") {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('userStatus', '1');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Flushbar(
            messageText: Text("Your Profile has been successfully updated!",
                style: TextStyle(
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                    color: Colors.white)),
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.blue[300],
            ),
            duration: Duration(seconds: 12),
            leftBarIndicatorColor: Colors.blue[300],
            backgroundColor: Colors.black)
          ..show(context);
      });
      Get.to(Home());
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Flushbar(
            messageText: Text(response.data.toString(),
                style: TextStyle(
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                    color: Colors.white)),
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.blue[300],
            ),
            duration: Duration(seconds: 12),
            leftBarIndicatorColor: Colors.blue[300],
            backgroundColor: Colors.black)
          ..show(context);
      });
      Get.to(Home());
    }
  }

  void cancelUpload() {
    Get.to(Home());
  }
}
