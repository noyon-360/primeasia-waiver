import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pau_waiver/apis/pau_semester_cost_api.dart';

class CostCalculationModel {
  int totalCredit;
  int totalWaiver;

  CostCalculationModel({
    this.totalCredit = 0,
    this.totalWaiver = 0,
  });

  Future<Map<String, dynamic>> calculateCost(
      int totalCredit, int totalWaiver) async {
    try {
      final response = await http.post(
        Uri.parse(Apis.pauSemesterCostApi), // Your API URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'total_credit': totalCredit,
          'total_waiver': totalWaiver,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'total_cost': data['data']['total_cost'],
          'per_credit_const' : data['data']['per_credit_const'],
          'semester_cost' : data['data']['semester_cost'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to calculate cost!',
        };
      }
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': 'Errors : $e',
      };
    }
  }
}
