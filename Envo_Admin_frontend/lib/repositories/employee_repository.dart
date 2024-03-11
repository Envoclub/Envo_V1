import 'dart:convert';
import 'dart:developer';

import 'package:envo_admin_dashboard/models/employee_model.dart';
import 'package:flutter/foundation.dart';

import '../utils/meta_strings.dart';
import 'auth_repository.dart';
import 'package:http/http.dart' as http;

class EmployeeRepository {
  AuthRepository authRepository;
  EmployeeRepository(this.authRepository);

  getEmployee() async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      String url = MetaStrings.baseUrl + MetaStrings.getAllEmployees;

      var response = await http.get(Uri.parse(url), headers: headers);
      log(headers.toString());
      debugPrint(response.body);
      if (response.statusCode == 200) {
        return employeeFromJson(response.body);
      } else {
        throw jsonDecode(response.body)["detail"] ??
            jsonDecode(response.body)["token"] ??
            "";
      }
    } catch (e) {
      rethrow;
    }
  }

  addEmployee(
      {required String email,
      required String username,
      required String password,
      required int companyID}) async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      String url =
          MetaStrings.baseUrl + MetaStrings.addEmployee;
      var params = {"email": email, "password1": password, "username": username,"password2":password,"company":companyID};
      var response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(params));
      log(headers.toString());
      debugPrint(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw jsonDecode(response.body)["detail"] ??
            jsonDecode(response.body)["token"] ??
            "";
      }
    } catch (e) {
      rethrow;
    }
  }

  deleteEmployee({required String companyID, required String pk}) async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      String url = MetaStrings.baseUrl +
          MetaStrings.deleteEmployee +
          "$companyID/" +
          "$pk/";

      var response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );
      log(headers.toString());
      log(url.toString());
     log(response.statusCode.toString());
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw jsonDecode(response.body)["detail"] ??
            jsonDecode(response.body)["token"] ??
            "";
      }
    } catch (e) {
      rethrow;
    }
  }
}
