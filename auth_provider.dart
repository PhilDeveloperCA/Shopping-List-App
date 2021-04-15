import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:html';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  String jwt;
  String username;
  bool authenticated = false;

  /*
   final _storage = FlutterSecureStorage();
  void init() async {
    jwt = await _storage.read(key: 'jwt');
  }
  */
  AuthProvider() {
    init();
  }

  void init() async {
    jwt = _localStorage['jwt'];
    username = _localStorage['jwt'];
    if (jwt != null && username != null) {
      authenticated = true;
    } else
      authenticated = false;
  }

  final Storage _localStorage = window.localStorage;

  var client = http.Client();
  static const url = "http://192.168.1.122:5000/auth/signin";

  Future<void> login(String username, String password) async {
    var response = await client.post(
        new Uri.http("192.168.1.122:5000", "/auth/signin"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}));
    final parsed = jsonDecode(response.body);
    if (parsed['jwt'] != null) {
      jwt = parsed['jwt'];
      username = parsed['username'];
      authenticated = true;
      notifyListeners();
      /*await _storage.write(
      key: 'jwt',
      value: parsed['jwt'],
    );*/
      _localStorage['jwt'] = jwt;
      _localStorage['username'] = username;
      print(_localStorage['jwt']);
    }
  }

  logout() {
    jwt = null;
    username = null;
    authenticated = false;
    _localStorage.remove('jwt');
    _localStorage.remove('username');
    //flutter secure storage
    //flutter secure storage
  }
}
