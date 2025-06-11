import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/colors/colors.dart';
import '../../../utils/routes/route_names.dart';
import 'logout_config.dart';

class LogoutDialog extends StatelessWidget {
  final AuthService authService = AuthService();

  LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: SvgPicture.asset(
        'icons/logout.svg',
        width: 100,
        height: 100,
      ),
      // title: Text(
      //   'Logout',
      //   style: GoogleFonts.poppins(
      //     fontSize: 20,
      //     color: oBlack,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
      content: Text(
        'Oh no! are you leaving...\nAre you sure?',
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: oBlack,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    oGreen,
                  ),
                  // side: MaterialStateProperty.resolveWith<BorderSide>(
                  //       (Set<MaterialState> states) {
                  //     return const BorderSide(color: oBlue, width: 1);
                  //   },
                  // ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Naah, Just kidding',
                    style: GoogleFonts.poppins(color: oWhite, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  await _logout(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    oRed.withOpacity(0.1),
                  ),
                  side: MaterialStateProperty.resolveWith<BorderSide>(
                        (Set<MaterialState> states) {
                      return const BorderSide(color: oRed, width: 1);
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Yes, Log Me Out',
                    style: GoogleFonts.poppins(color: oRed, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    await authService.clearToken();
    Navigator.pushNamedAndRemoveUntil(context, RouteNames.loginScreen, (route) => false);
  }
}
