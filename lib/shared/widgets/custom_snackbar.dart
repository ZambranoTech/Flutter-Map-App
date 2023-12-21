
import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({super.key, required super.content, required duration, required btnLabel}) : super(
    duration: duration,
    action: SnackBarAction(
      label: btnLabel, 
      onPressed: () {

      }
    )
  );

}