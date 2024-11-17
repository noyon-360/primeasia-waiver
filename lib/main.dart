import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pau_waiver/model/cost_calculation_model.dart';
import 'package:pau_waiver/provider/InternetControllerProvider.dart';
import 'package:pau_waiver/provider/waiver_controller.dart';
import 'package:pau_waiver/screens/waiver_check_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(InternetController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WaiverCheckScreen(),
    );
  }
}