import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shop/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _token != null &&
        _expiryDate.isAfter(DateTime.now())) return _token;
    return null;
  }

  Future<bool> isLogin() async {
    final sharedPref = await SharedPreferences.getInstance();
    if (!sharedPref.containsKey('user_data')) return false;
    final data =
        json.decode(sharedPref.getString('user_data')) as Map<String, Object>;
    _expiryDate = DateTime.parse(data['expiryDate']);

    if (_expiryDate.isBefore(DateTime.now())) {
      _expiryDate = null;
      sharedPref.clear();
      return false;
    }
    _userId = data['userId'];
    _token = data['idToken'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> _authenticate(
      String email, String password, String urlType) async {
    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlType?key=AIzaSyBqK2QCaun_YoEZ7NkQ8KF64HwlzzhWdFM";

      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final sharedPref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _userId,
        'idToken': _token,
        'expiryDate': _expiryDate.toIso8601String()
      });
      sharedPref.setString('user_data', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
