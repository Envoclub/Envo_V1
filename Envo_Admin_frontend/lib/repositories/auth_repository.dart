import 'dart:convert';
import 'dart:developer';

import 'package:envo_admin_dashboard/models/tile_data.dart';
import 'package:envo_admin_dashboard/models/user_model.dart';
import 'package:envo_admin_dashboard/utils/meta_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  String? accessToken;
  String? refreshToken;
  FlutterSecureStorage storage = FlutterSecureStorage();
  initTokens() async {
    accessToken = await storage.read(key: "accessToken");
    refreshToken = await storage.read(key: "refreshToken");
  }

  setTokens(String accessTokenValue, String refreshTokenValue) async {
    accessToken = accessTokenValue;
    refreshToken = refreshTokenValue;
    log("access $accessToken refresh $refreshToken");
    await storage.write(key: "accessToken", value: accessToken);
    await storage.write(key: "refreshToken", value: refreshToken);
  }

  login(String email, String password) async {
    var params = {"email": email, "password": password};
    var headers = {"Content-Type": "application/json"};
    try {
      String url = MetaStrings.baseUrl + MetaStrings.loginEndPoint;
      log(url);
      var response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(params));
      var parsedValue = jsonDecode(response.body);
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await setTokens(parsedValue["key"], '');
        return;
      } else {
        throw parsedValue['detail'];
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  getUserDetails() async {
    var headers = {
      "Authorization": "Token " + accessToken!,
      "Content-type": "application/json"
    };
    log(headers.toString());
    try {
      String url = MetaStrings.baseUrl + MetaStrings.getUserEndPoint;
      log(url);

      FlutterSecureStorage storage = FlutterSecureStorage();
      var response = await http.get(Uri.parse(url), headers: headers);
      debugPrint(response.body);
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      rethrow;
    }
  }

  getTileDetails() async {
    var headers = {
      "Authorization": "Token " + accessToken!,
      "Content-type": "application/json"
    };
    log(headers.toString());
    try {
      String url = MetaStrings.baseUrl + MetaStrings.tileData;
      log(url);

      FlutterSecureStorage storage = FlutterSecureStorage();
      var response = await http.get(Uri.parse(url), headers: headers);
      debugPrint(response.body);
      if (response.statusCode == 200) {
        return tileDataFromJson(response.body);
      } else {
        throw "Something went wrong ${response.body}";
      }
    } catch (e) {
      rethrow;
    }
  }

  logout() async {
    try {
      await storage.deleteAll();
      return;
    } catch (e) {
      rethrow;
    }
  }

  activate(String uid, String token) async {
    try {
      var headers = {"Content-type": "application/json"};
      String url = MetaStrings.baseUrl + MetaStrings.activationEndPoint;
      log(url);
      var params = {
        "uid": uid,
        "token": token,
      };
      log(params.toString());
      var response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(params));
      log("response is" + response.body);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return [true];
      } else {
        throw jsonDecode(response.body)['detail'] ?? '';
      }
    } catch (e) {
      log(e.toString());
      return [false, e.toString()];
    }
  }

  resetPasswordConfirm(String uid, String token, String password) async {
    try {
      var headers = {"Content-type": "application/json"};
      String url = MetaStrings.baseUrl + MetaStrings.resetPasswordConfirm;
      log(url);
      var params = {
        "uid": uid,
        "token": token,
        "new_password": password,
        "re_new_password": password
      };
      log(params.toString());
      var response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(params));
      log("response is" + response.body);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return [true];
      } else {
        throw jsonDecode(response.body)['detail'] ??
            jsonDecode(response.body)['token'] ??
            '';
      }
    } catch (e) {
      log(e.toString());
      return [false, e.toString()];
    }
  }

  reset(String email) async {
    try {
      var headers = {"Content-type": "application/json"};
      String url = MetaStrings.baseUrl + MetaStrings.resetPasswordMail;
      log(url);
      var params = {
        "email": email,
      };
      log(params.toString());
      var response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(params));
      log("response is" + response.body);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return [true];
      } else {
        throw jsonDecode(response.body)['detail'] ??
            jsonDecode(response.body)['token'] ??
            '';
      }
    } catch (e) {
      log(e.toString());
      return [false, e.toString()];
    }
  }
}
