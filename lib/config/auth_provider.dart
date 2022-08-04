import 'dart:convert';
import 'package:flutter/material.dart';
import 'cafe_api.dart';
import 'local_storage.dart';
import 'notifications_service.dart';

enum AuthStatus { authenticated, notAuthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus authStatus = AuthStatus.notAuthenticated;
  bool authLoading = true;
  String authNames = "";
  String authAvatar = "";
  String authRol = "";

  AuthProvider() {
    isAuthenticated();
  }

  login({
      required String email,
      required String password
  }) async {
    try {
      const url = "/v1/manager/login";
      final data = {'email': email, 'password': password};
      final resp = await CafeApi.post(url, data);
      final authResponse = AuthResponse.fromMap(resp);
      authRol = authResponse.rol;
      authNames = authResponse.names;     
      authAvatar = authResponse.avatar;     
      authStatus = AuthStatus.authenticated;
      LocalStorage.prefs.setString('token', authResponse.token);
      CafeApi.configureDio();
      notifyListeners();
    } catch (e) {
      NotificationsService.showSnackbarError('Email / Password wrong');
    }
  }

  logout() {
    LocalStorage.prefs.remove('token');
    authStatus = AuthStatus.notAuthenticated;
    CafeApi.configureDio();
    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    final token = LocalStorage.prefs.getString('token');
    if (token == null) {
      Future.delayed(const Duration(seconds: 5), () {
        authStatus = AuthStatus.notAuthenticated;
        authLoading = false;
        notifyListeners();
      });
      return false;
    }

    try {
      const url = "/v1/manager/auth";
      final resp = await CafeApi.httpGet(url);
      final authResponse = AuthResponse.fromMap(resp);
      authRol = authResponse.rol;
      authNames = authResponse.names;     
      authAvatar = authResponse.avatar;
      authStatus = AuthStatus.authenticated;
      authLoading = false;
      LocalStorage.prefs.setString('token', authResponse.token);
      notifyListeners();
      return true;
    } catch (e) {
      Future.delayed(const Duration(seconds: 5), () {
        LocalStorage.prefs.remove('token');
        authStatus = AuthStatus.notAuthenticated;
        authLoading = false;
        notifyListeners();
      });
      return false;
    }
  }
}


class AuthResponse {
  AuthResponse({
    required this.names,
    required this.avatar,
    required this.rol,
    required this.token,
  });
  String names;
  String avatar;
  String rol;
  String token;

  factory AuthResponse.fromJson(String str) =>
      AuthResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        names: json["names"],
        avatar: json["avatar"],
        rol: json["rol"],
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "names": names,
        "avatar": avatar,
        "rol": rol,
        "token": token,
      };
}