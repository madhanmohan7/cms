import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/colors/colors.dart';

void showEditAlertDialog(
    BuildContext context, String title, String content, bool status) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
      return AlertDialog(
        backgroundColor: oTransparent,
        elevation: 0,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 400,
            //height: 350,
            decoration: BoxDecoration(
              color: oWhite,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset("animations/edit2.json", width: 200),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: oBlack,
                      fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  content,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: oBlack,
                      fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
