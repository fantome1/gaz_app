import 'package:flutter/material.dart';

class MyFunction {
  static void onChangePage(context, Widget page) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: ((context, animation, secondaryAnimation) {
            return page;
          }),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
  }
}
