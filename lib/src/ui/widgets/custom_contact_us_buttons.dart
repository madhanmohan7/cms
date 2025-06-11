import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors/colors.dart';

class ChatButton extends StatelessWidget {
  final String imagePath;
  final String buttonText;

  const ChatButton({
    Key? key,
    required this.imagePath,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 70,
      decoration: BoxDecoration(
        gradient: oTransparentGradient,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(imagePath),
            width: 50,
            height: 50,
          ),
          const SizedBox(width: 10.0),
          Text(
            buttonText,
            style: GoogleFonts.poppins(
                color: oWhite,
                fontSize: 13.0,
                fontWeight: FontWeight.normal
            ),
          ),
        ],
      ),
    );
  }
}
