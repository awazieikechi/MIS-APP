import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'https://mis.michelleandanthony.net/api';

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
    var fullUrl = _url + apiUrl;
    if (apiUrl == '/profile/update' ||
        apiUrl == '/changepassword' ||
        apiUrl == '/payments' ||
        apiUrl == '/upgrade') {
      await _getToken();
    }
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(fullUrl, headers: _setHeaders());
  }
}
