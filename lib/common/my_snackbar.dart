import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

void mySnackbar(BuildContext context, String error) {
  final snackBar = SnackBar(content: error.text.make());

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
