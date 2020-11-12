// To parse this JSON data, do
//  Details for members that have not uploaded details
//     final userDetails = userDetailsFromJson(jsonString);

import 'dart:convert';

UserDetails userDetailsFromJson(String str) =>
    UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

class UserDetails {
  UserDetails({
    this.profilefailed,
    this.user,
  });

  String profilefailed;
  User user;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        profilefailed: json["profilefailed"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "profilefailed": profilefailed,
        "user": user.toJson(),
      };
}

class User {
  User({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.phonenumber,
    this.dateOfBirth,
    this.position,
    this.homeAddress,
    this.organisation,
    this.organisationAddress,
    this.membershipSubscription,
    this.gender,
    this.city,
    this.state,
    this.country,
    this.membershipStatus,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String firstname;
  String lastname;
  String username;
  String email;
  String phonenumber;
  var dateOfBirth;
  String position;
  String homeAddress;
  String organisation;
  String organisationAddress;
  String membershipSubscription;
  String gender;
  String city;
  String state;
  String country;
  String membershipStatus;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        phonenumber: json["phonenumber"],
        dateOfBirth: json["date_of_birth"].toString(),
        position: json["position"],
        homeAddress: json["home_address"],
        organisation: json["organisation"],
        organisationAddress: json["organisation_address"],
        membershipSubscription: json["membership_subscription"],
        gender: json["Gender"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        membershipStatus: json["membership_status"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "email": email,
        "phonenumber": phonenumber,
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "position": position,
        "home_address": homeAddress,
        "organisation": organisation,
        "organisation_address": organisationAddress,
        "membership_subscription": membershipSubscription,
        "Gender": gender,
        "city": city,
        "state": state,
        "country": country,
        "membership_status": membershipStatus,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
