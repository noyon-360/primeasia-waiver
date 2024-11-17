import 'package:flutter/material.dart';

InputDecoration customInputDecoration({
  required String labelText,
  required String hintText,
  IconButton? suffixIcon,
  required BuildContext context, // Pass context to determine the current theme
}) {
  // Get the current theme (light or dark mode)
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: isDarkMode ? Colors.white70 : Colors.grey[600], // Light mode: grey, Dark mode: light grey
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        color: isDarkMode ? Colors.white54 : Colors.grey[400], // Light mode: grey, Dark mode: white grey
      ),
      filled: true,
      fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200], // Dark mode: darker grey, Light mode: light grey
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: isDarkMode ? Colors.white24 : Colors.grey, // Dark mode: lighter border, Light mode: grey
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: isDarkMode ? Colors.blueGrey : Colors.blueGrey, // Same focused border color for both modes
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: isDarkMode ? Colors.white30 : Colors.grey, // Dark mode: lighter border, Light mode: grey
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: isDarkMode ? Colors.redAccent : Colors.red, // Dark mode: red accent, Light mode: red
          width: 2.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: isDarkMode ? Colors.redAccent : Colors.redAccent, // Same error focused border color for both modes
          width: 2.0,
        ),
      ),
      suffixIcon: suffixIcon, // Optional icon
      counterText: ""
  );
}
