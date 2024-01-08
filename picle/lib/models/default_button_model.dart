import 'package:flutter/material.dart';

final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  minimumSize: const Size(double.maxFinite, 48),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  ),
  disabledBackgroundColor: const Color(0xFFEDEEF0),
  disabledForegroundColor: const Color(0xFF9D9D9D),
  backgroundColor: const Color(0xFFEDEEF0),
  foregroundColor: const Color(0xFF333333),
);
