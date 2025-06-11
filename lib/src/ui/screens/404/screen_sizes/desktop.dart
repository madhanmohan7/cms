import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/logger.dart';
import '../../../../utils/routes/route_names.dart';

class ErrorUnkownDesktopUi extends StatefulWidget {
  const ErrorUnkownDesktopUi({super.key});

  @override
  State<ErrorUnkownDesktopUi> createState() => _ErrorUnkownDesktopUiState();
}

class _ErrorUnkownDesktopUiState extends State<ErrorUnkownDesktopUi> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: constraints.maxWidth > 1350 ? 8 : 9,
                child: _buildIntroText(context),
              ),
              Flexible(flex: 6, child: _buildIntroImageContainer()),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildIntroText(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Page Not Found",
            style: GoogleFonts.poppins(
              fontSize: 45,
              color: oBlack,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 15),
          Text(
            "We're sorry, the page you requested could not be found.\nPlease go back to the homepage.",
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: oBlack,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () {
              LoggerUtil.getInstance.print("Back to home button pressed");
              Navigator.pushNamed(context, RouteNames.homeScreen);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(oBlack),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              minimumSize: MaterialStateProperty.all(const Size(120, 60)),
            ),
            child: Text(
              "Go To Home",
              style: GoogleFonts.poppins(
                color: oWhite,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildIntroImageContainer() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: SvgPicture.asset(
      "Backgrounds/error.svg",
      // width: 250,
    ),
  );
}
