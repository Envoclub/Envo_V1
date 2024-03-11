import 'dart:convert';
import 'dart:developer';

import 'package:envo_admin_dashboard/repositories/auth_repository.dart';
import 'package:envo_admin_dashboard/utils/meta_assets.dart';
import 'package:envo_admin_dashboard/utils/meta_strings.dart';
import 'package:http/http.dart' as http;
import '../models/bar_chart.dart';
import '../models/co2_graph.dart';
import '../models/line_chart.dart';
import '../models/pie_chart.dart';

class ChartRepository {
  AuthRepository authRepository;
  ChartRepository(this.authRepository);
  Future<Co2GraphData> getCo2Chart(String id) async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      log(id);
      String url = MetaStrings.baseUrl +"/activities/"+id+ MetaStrings.co2ChartEndPoint;

      var response = await http.get(Uri.parse(url), headers: headers);
      log(response.body);
      if (response.statusCode == 200) {
        return co2GraphDataFromJson(response.body);
      } else {
        throw jsonDecode(response.body)["detail"] ??
            jsonDecode(response.body)["token"] ??
            "";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PieChartApiData>> getPieChart() async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      String url = MetaStrings.baseUrl + MetaStrings.piechartEndPoint;

      var response = await http.get(Uri.parse(url), headers: headers);
      log(headers.toString());
      log("chart is here  ${response.body}");
      if (response.statusCode == 200) {
        return pieChartApiDataFromJson(response.body);
      } else {
        throw jsonDecode(response.body)["detail"] ??
            jsonDecode(response.body)["token"] ??
            "";
      }
    } catch (e) {
      rethrow;
    }
  }
   Future<List<BarChartApiData>> getBarChart() async {
    try {
      var headers = {
        "Authorization": "Token " + authRepository.accessToken!,
        "Content-type": "application/json"
      };
      String url = MetaStrings.baseUrl + MetaStrings.barchartEndPoint;

      var response = await http.get(Uri.parse(url), headers: headers);
      log(headers.toString());
      log("bar chart is here  ${response.body}");
      if (response.statusCode == 200) {
        return barChartApiDataFromJson(response.body);
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
