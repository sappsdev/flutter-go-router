import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_routes/config/notifications_service.dart';
import 'package:flutter_routes/routes/router.dart';

import 'auth_provider.dart';
import 'constants.dart';
import 'local_storage.dart';

class CafeApi {
  static final Dio _dio = Dio();
  static void configureDio() {
    _dio.options.baseUrl = backendUrl;
    _dio.options.headers = {
      'x-token': LocalStorage.prefs.getString('token') ?? ''
    };
  }

  static Future httpGet(String path) async {
    try {
      final resp = await _dio.get(path);
      return resp.data;
    } catch (e) {
      checkError(e);
    }
  }

  static Future post(String path, Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      final resp = await _dio.post(path, data: formData);
      return resp.data;
    } catch (e) {
      checkError(e);
    }
  }

  static Future put(String path, Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      final resp = await _dio.put(path, data: formData);
      return resp.data;
    } catch (e) {
      checkError(e);
    }
  }

  static Future delete(String path, Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      final resp = await _dio.delete(path, data: formData);
      return resp.data;
    } catch (e) {
      checkError(e);
    }
  }

  static Future uploadFile(String path, Uint8List bytes) async {
    try {
      final formData =
          FormData.fromMap({'file': MultipartFile.fromBytes(bytes)});
      final resp = await _dio.put(path, data: formData);
      return resp.data;
    } catch (e) {
      checkError(e);
    }
  }
}

checkError(e) {
  if (e.response!.statusCode == 401) {
    LocalStorage.prefs.remove('token');
    authProvider.authStatus = AuthStatus.notAuthenticated;
  }
}
