import 'package:pau_waiver/model/cost_calculation_model.dart';

class CostCalculationController {
  final CostCalculationModel _model;

  CostCalculationController(this._model);

  Future<Map<String, dynamic>> getTotalCost(int totalCredit, int totalWaiver) async {
    return await _model.calculateCost(totalCredit, totalWaiver);
  }
}