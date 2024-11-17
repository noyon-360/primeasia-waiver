import 'package:get/get.dart';
import 'package:pau_waiver/controller/cost_calculation_controller.dart';
import 'package:pau_waiver/model/cost_calculation_model.dart';

class WaiverController extends GetxController {
  final CostCalculationController _controller;

  var totalCost = "".obs;
  var perCreditCost = "".obs;
  var semesterCost = "".obs;

  var isLoading = false.obs;


  WaiverController(CostCalculationModel model) : _controller = CostCalculationController(model);


  Future<void> calculateCost(int totalCredit, int totalWaiver) async {
    if (totalCredit == 0) {
      Get.snackbar('Error', "Please fill in both fields", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      final result = await _controller.getTotalCost(totalCredit, totalWaiver);

      if( result['success']) {
        totalCost.value = result['total_cost'].toString();
        perCreditCost.value = result['per_credit_const'].toString();
        semesterCost.value = result['semester_cost'].toString();
      }
      else {
        Get.snackbar("Error", "Network error. Please check you connection", snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void resetValue () {
    totalCost.value = "";
    perCreditCost.value = "";
    semesterCost.value = "";
  }

}