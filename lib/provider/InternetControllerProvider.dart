import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    print("InternetController initialized");
    _checkInitialConnection();
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      NetStatus(results.first); // Process the first result
    });
  }

  Future<void> _checkInitialConnection() async {
    print("Checking initial connection");
    // If it returns a list, you would access the first element
    var results = await _connectivity.checkConnectivity();
    ConnectivityResult result =
        results.isNotEmpty ? results.first : ConnectivityResult.none;
    print("Initial connection status: $result");
    // NetStatus(result);
  }

  //
  // Future<void> _checkInitialConnection() async {
  //   print("Checking initial connection");
  //   // Adjusting for the return type based on the package version
  //   ConnectivityResult result = await _connectivity.checkConnectivity(); // Ensure this returns a single ConnectivityResult
  //   print("Initial connection status: $result");
  //   NetStatus(result);
  // }

  void NetStatus(ConnectivityResult result) {
    print("Network status changed: $result");
    if (result == ConnectivityResult.none) {
      print("No internet connection - attempting to show snackbar");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Internet connectivity',
          "Check your internet connection",
          isDismissible: false,
          duration: const Duration(days: 365),
        );
      });

      // WidgetsBinding.instance

      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   print("Post frame callback - showing snackbar");
      //
      //   // Check if Get.context is available before accessing size
      //   double height = Get.context?.size?.height ?? 600; // Use a default value if null
      //
      //   Get.rawSnackbar(
      //     titleText: const Text("hello"),
      //     messageText: Container(),
      //     backgroundColor: Colors.transparent,
      //     isDismissible: false,
      //     duration: const Duration(days: 1),
      //   );
      // });
    } else {
      if (Get.isSnackbarOpen) {
        print("Closing snackbar");
        Get.closeCurrentSnackbar();
      }
    }
  }
}
