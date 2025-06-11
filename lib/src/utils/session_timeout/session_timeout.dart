import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../ui/screens/logout/logout_config.dart';
import '../colors/colors.dart';
import '../routes/route_names.dart';

// Assuming AuthService and RouteNames are defined elsewhere in your code

class JwtExpirationHandler {
  final BuildContext context;
  final AuthService authService;
  Timer? _timer;

  JwtExpirationHandler({
    required this.context,
    required this.authService,
  });

  void startTimer() {
    print('Timer started');
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      _checkJwtExpiration();
    });
  }

  void stopTimer() {
    print('Timer stopped');
    _timer?.cancel();
  }

  Future<void> _checkJwtExpiration() async {
    print('Checking JWT expiration');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtExpTime = prefs.getString('jwtexptime');

    if (jwtExpTime != null) {
      final DateFormat format = DateFormat('yy-MM-dd HH:mm:ss');
      try {
        final jwtExpDate = format.parse(jwtExpTime);
        final now = DateTime.now();
        print('JWT expiration date: $jwtExpDate');
        print('Current date: $now');

        if (now.isAfter(jwtExpDate)) {
          print('JWT has expired');
          if (context.mounted) {
            await _showTimeoutDialog();
            stopTimer();
          }
        }
      } catch (e) {
        // Handle parsing error
        if (context.mounted) {
          print('Error parsing JWT expiration time: $e');
        }
      }
    } else {
      print('JWT expiration time is null');
      if (context.mounted) {
        stopTimer();
        await _showTimeoutDialog();
      }
    }
  }

  Future<void> _showTimeoutDialog() async {
    print('Showing timeout dialog');
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          child: Container(
              width: 400,
              height: 350,
              decoration: BoxDecoration(
                color: oWhite,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              child: Column(
                children: [
                  Lottie.asset("animations/timeout.json", height: 180),
                  const SizedBox(height: 20,),
                  Text("Session Timeout",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: oBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text("Your session has expired. Please log in again.",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: oBlack,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              )
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 6000));
    Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
    await authService.clearToken();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.loginScreen, (route) => false);
    }
  }

  void dispose() {
    stopTimer();
  }
}
