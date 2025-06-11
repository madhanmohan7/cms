
import 'package:flutter/material.dart';

import '../../../main.dart';

class Navigation {
  static finishAndNavigate(BuildContext context, Widget screen) {
    Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static navigateOver(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static navigateNew(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => screen),
        ModalRoute.withName("/LoginScreen"));
  }

  static finish(BuildContext context) {
    Navigator.pop(context);
  }

  static navigate(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }
  static navigateOnError(dynamic error) {
    if(error.toString().contains("[403]") || error.toString().contains("[401]")) {
    }
  }
}
