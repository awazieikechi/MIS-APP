//  Details for members that have uploaded their details

class UserApi {
  String status;
  List<User> user;

  UserApi({this.status, this.user});

  factory UserApi.fromJson(Map<String, dynamic> json) {
    return UserApi(
      status: json['status'],
      user: parseUser(json),
    );
  }

  static List<User> parseUser(userJson) {
    var list = userJson['user'] as List;
    List<User> userList = list.map((data) => User.fromJson(data)).toList();
    return userList;
  }
}

class User {
  final String firstname;
  final String lastname;
  final int id;
  var username;
  var email;
  var phonenumber;
  var dateOfBirth;
  final String position;
  var homeAddress;
  var organisationAddress;
  var organisation;
  final String membershipSubscription;
  final String gender;
  final String city;
  final String state;
  final String country;
  var member_id;
  var passport_image;

  User(
      {this.firstname,
      this.lastname,
      this.id,
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
      this.country,
      this.state,
      this.member_id,
      this.passport_image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      email: json['email'],
      phonenumber: json['phonenumber'],
      dateOfBirth: json['date_of_birth'].toString(),
      position: json['position'],
      homeAddress: json['home_address'],
      organisation: json['organisation'],
      organisationAddress: json['organisation_address'],
      membershipSubscription: json['membership_subscription'],
      gender: json['Gender'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      member_id: json['member_id'],
      passport_image: json['passport_image'],
    );
  }
}
