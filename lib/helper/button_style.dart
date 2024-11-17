import 'package:flutter/material.dart';

class ButtonStyles {
  static final ButtonStyle formSubmitButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue.shade900,
    elevation: 5,
    textStyle: const TextStyle(
        fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
