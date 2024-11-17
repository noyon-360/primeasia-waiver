import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:pau_waiver/controller/cost_calculation_controller.dart';
import 'package:pau_waiver/helper/button_style.dart';
import 'package:pau_waiver/helper/text_form_field_decoration.dart';
import 'package:pau_waiver/model/cost_calculation_model.dart';
import 'package:pau_waiver/provider/waiver_controller.dart';
import 'package:pau_waiver/screens/navigation_bar.dart';

class WaiverCheckBody extends StatelessWidget {
  WaiverCheckBody({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class WaiverCheckScreen extends StatefulWidget {
  const WaiverCheckScreen({super.key});

  @override
  State<WaiverCheckScreen> createState() => _WaiverCheckScreenState();
}

class _WaiverCheckScreenState extends State<WaiverCheckScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _creditTextController = TextEditingController();
  final TextEditingController _waiverTextController = TextEditingController();

  final CostCalculationModel _model = CostCalculationModel();
  late CostCalculationController _controller;

  final FocusNode _focusNode = FocusNode();

  String totalCost = "";
  String perCreditCost = "";
  String semesterCost = "";

  bool isLoading = false;
  bool isCopied = false;

  bool isMobile = (!kIsWeb && (Platform.isAndroid || Platform.isIOS));


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!isMobile){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }


    _controller = CostCalculationController(_model);
  }

  @override
  dispose() {
    // _focusNode.dispose();
    super.dispose();
  }

  Future<void> _calculateCost() async {
    final totalCredit = int.tryParse(_creditTextController.text) ?? 0;
    final totalWaiver = int.tryParse(_waiverTextController.text) ?? 0;

    if (totalCredit == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in the both fields')));
    }

    try {
      setState(() {
        isLoading = true;
      });
      final result = await _controller.getTotalCost(totalCredit, totalWaiver);

      if (result['success']) {
        setState(() {
          totalCost = result['total_cost'].toString();
          perCreditCost = result['per_credit_const'].toString();
          semesterCost = result['semester_cost'].toString();
          isLoading = false;
        });
      } else {
        // Handle error
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Network error. Please check your connection.")));
      }
    } catch (e) {
      print('Error : $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("building");
    return Scaffold(
      // body: _desktopScreen(context),
      drawer: isMobile
          ? Drawer(
              child: SingleChildScrollView(
                child: Column(
                  children: [buildHeader(context), buildMenuItems(context)],
                ),
              ),
            )
          : null,
      appBar: isMobile
          ? AppBar(
              title: const Text('Waiver Calculator'),
            )
          : null,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Builder(builder: (context) {
          return Column(
            children: [
              if(!isMobile)
                const NavigationBarWeb(),
              Expanded(child: _desktopScreen(context)),
            ],
          );
        }),
      ),
    );
  }

  Widget _desktopScreen(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: const Image(
                    image: AssetImage('assets/images/pau_logo_png.png')),
              ),
              const Text(
                "Primeasia University",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SizedBox(
                  // height: 200,
                  child: _form(context),
                ),
              ),
              if (totalCost != "")
                Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (totalCost.isNotEmpty) {
                          await Clipboard.setData(ClipboardData(text: totalCost));
                          setState(() {
                            isCopied = true; // Change icon to indicate copied
                          });
                          if(isMobile){
                            const snack = SnackBar(
                                content: Text("Text copied"), duration: Duration(seconds: 2));
                            ScaffoldMessenger.of(context).showSnackBar(snack);
                          }

                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              isCopied = false;
                            });
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your total cost : $totalCost Tk',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(isCopied ? Icons.check_outlined : Icons.copy),
                        ],
                      ),
                    ),
                    Text('Semester cost : $semesterCost Tk'),
                    Text('Per Credit cost : $perCreditCost Tk'),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //         width: 100,
              //         decoration: const BoxDecoration(color: Colors.blue),
              //         child: IconButton(
              //
              //             onPressed: () {}, icon: const Text("Course List"))),
              //     const SizedBox(width: 10),
              //     Container(
              //         width: 100,
              //         decoration: const BoxDecoration(color: Colors.blue),
              //         child: IconButton(onPressed: () {}, icon: const Text("ERP")))
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              "Welcome",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text("Find your total cost by providing the details"),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              focusNode: isMobile ? _focusNode.parent : _focusNode,
              controller: _creditTextController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
              ],
              decoration: customInputDecoration(
                  labelText: 'Credit',
                  hintText: "Enter your total credit",
                  context: context),
              validator: (value) {
                if (value == null || value.isEmpty || int.parse(value) == 0) {
                  return "Enter your credits";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _waiverTextController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
              ],
              decoration: customInputDecoration(
                  labelText: 'Waiver',
                  hintText: "Enter your total waiver",
                  context: context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your waiver";
                }
                return null;
              },
              onFieldSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  _calculateCost(); // Calculate total cost when pressed
                }
              },
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                  style: ButtonStyles.formSubmitButtonStyle,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _calculateCost(); // Calculate total cost when pressed
                      });
                    }
                  },
                  child: const Text(
                    "Calculate",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            if (isLoading) const LinearProgressIndicator()
          ],
        ));
  }

  Widget buildHeader(BuildContext context) => Container(
        color: Colors.blue.shade900,
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
              child: const Image(
                  image: AssetImage('assets/images/pau_logo_png.png')),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'Primeasia University',
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            const Text(
              'Waiver Calculation',
              style: TextStyle(fontSize: 18, color: Colors.white),
            )
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.percent_outlined),
            title: const Text("Calculate"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: const Text("Course List"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.account_box_outlined),
            title: const Text("ERP"),
            onTap: () {},
          ),
          const Divider(
            color: Colors.blueAccent,
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Setting"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.more_vert),
            title: const Text("About"),
            onTap: () {},
          ),
        ],
      );
}
