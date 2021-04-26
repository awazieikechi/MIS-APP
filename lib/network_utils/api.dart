import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String api_base_url = 'https://mis.michelleandanthony.net/api';
  final String api_base_url_storage =
      'https://mis.michelleandanthony.net/storage/uploads/';

  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'));
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

  authData(data, apiUrl) async {
    var fullUrl = api_base_url + apiUrl;

    if (apiUrl == '/profile/update' ||
        apiUrl == '/changepassword' ||
        apiUrl == '/payments' ||
        apiUrl == '/upgrade') {
      await _getToken();
    }

    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = api_base_url + apiUrl;
    await _getToken();
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }
}
