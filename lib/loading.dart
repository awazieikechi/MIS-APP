import 'package:flutter/material.dart';
import 'package:niia_mis_app/pages/home.dart';
import 'package:niia_mis_app/pages/profile/editprofile.dart';
import 'package:niia_mis_app/network_utils/api.dart';
import 'package:niia_mis_app/network_utils/usermembershipdetail.dart';
import 'package:niia_mis_app/network_utils/userdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niia_mis_app/pages/payments/payments.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:get/get.dart';

class Loading {
  final String message = 'true';

  getUserStatus() async {
    var res = await Network().getData('/home');
    var result = json.decode(res.body);

    print(result);

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    if (result['paymentfailed'] != null) {
      var userdetail = userDetailsFromJson(res.body);
      localStorage.setString('userFirstName', userdetail.user.firstname);
      localStorage.setString('userLastName', userdetail.user.lastname);
      localStorage.setString('userEmail', userdetail.user.email);
      localStorage.setString('userPhoneNo', userdetail.user.phonenumber);
      localStorage.setString('userPosition', userdetail.user.position);
      localStorage.setString('userHomeAddress', userdetail.user.homeAddress);
      localStorage.setString(
          'userOrganisationAddress', userdetail.user.organisationAddress);
      localStorage.setString('userCity', userdetail.user.city);
      localStorage.setString('userBirthDate', userdetail.user.dateOfBirth);
      localStorage.setString('userGender', userdetail.user.gender);
      localStorage.setString('userCountry', userdetail.user.country);
      localStorage.setString('userState', userdetail.user.state);
      localStorage.setString('userPosition', userdetail.user.position);
      localStorage.setString('userOrganisation', userdetail.user.organisation);
      localStorage.setString(
          'userMembership', userdetail.user.membershipSubscription);
      localStorage.setString('userName', userdetail.user.username);
      Get.to(UserPayment(message: message));
    } else if (result['profilefailed'] != null) {
      var userdetail = userDetailsFromJson(res.body);
      localStorage.setString('userFirstName', userdetail.user.firstname);
      localStorage.setString('userLastName', userdetail.user.lastname);
      localStorage.setString('userEmail', userdetail.user.email);
      localStorage.setString('userPhoneNo', userdetail.user.phonenumber);
      localStorage.setString('userPosition', userdetail.user.position);
      localStorage.setString('userHomeAddress', userdetail.user.homeAddress);
      localStorage.setString(
          'userOrganisationAddress', userdetail.user.organisationAddress);
      localStorage.setString('userCity', userdetail.user.city);
      localStorage.setString('userBirthDate', userdetail.user.dateOfBirth);
      localStorage.setString('userGender', userdetail.user.gender);
      localStorage.setString('userCountry', userdetail.user.country);
      localStorage.setString('userState', userdetail.user.state);
      localStorage.setString('userPosition', userdetail.user.position);
      localStorage.setString('userOrganisation', userdetail.user.organisation);
      localStorage.setString(
          'userMembership', userdetail.user.membershipSubscription);
      localStorage.setString('userName', userdetail.user.username);

      Get.to(EditProfile(message: message));
    } else if (result['success']) {
      UserApi userdetail = UserApi.fromJson(result);
      print(userdetail.user[0].gender);
      localStorage.setString('userFirstName', userdetail.user[0].firstname);
      localStorage.setString('userLastName', userdetail.user[0].lastname);
      localStorage.setString('userEmail', userdetail.user[0].email);
      localStorage.setString('userPhoneNo', userdetail.user[0].phonenumber);
      localStorage.setString('userPosition', userdetail.user[0].position);
      localStorage.setString('userHomeAddress', userdetail.user[0].homeAddress);
      localStorage.setString(
          'userOrganisationAddress', userdetail.user[0].organisationAddress);
      localStorage.setString('userCity', userdetail.user[0].city);
      localStorage.setString('userBirthDate', userdetail.user[0].dateOfBirth);
      localStorage.setString('userGender', userdetail.user[0].gender);
      localStorage.setString('userCountry', userdetail.user[0].country);
      localStorage.setString('userState', userdetail.user[0].state);
      localStorage.setString('userPosition', userdetail.user[0].position);
      localStorage.setString(
          'userOrganisation', userdetail.user[0].organisation);
      localStorage.setString(
          'userMembership', userdetail.user[0].membershipSubscription);
      localStorage.setString('userImage', userdetail.user[0].passport_image);
      localStorage.setString('userMemberId', userdetail.user[0].member_id);
      localStorage.setString('userName', userdetail.user[0].username);
      localStorage.setString('userStatus', '1');
      Get.to(Home());
    }
  }
}
