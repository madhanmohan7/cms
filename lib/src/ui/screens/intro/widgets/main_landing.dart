
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/logger.dart';
import '../../../../utils/routes/route_names.dart';

class LandingSection extends StatefulWidget {
  const LandingSection({super.key});

  @override
  State<LandingSection> createState() => _LandingSectionState();
}

class _LandingSectionState extends State<LandingSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.37,
        width: double.infinity,
        //height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage('images/bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 30,
              right: 30,
              child: Container(
                  width: 500,
                  height: MediaQuery.of(context).size.width * 0.325,
                  //height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: oBlack.withOpacity(0.35),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome To\nOCPP CMS Portal",
                        style: GoogleFonts.poppins(
                            color: oWhite,
                            fontSize: 40,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '" Our portal provides you with the easiest way to find and use charging stations. '
                            'You can now charge your vehicle without any hassle and enjoy a seamless experience. '
                            'Join us and take advantage of our extensive network of charging stations and user-friendly interface. "',
                        style: GoogleFonts.poppins(
                            color: oWhite,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      const SizedBox(height: 10),
                      FittedBox(
                        child: InkWell(
                          onTap: () {
                            LoggerUtil.getInstance.print("login navigation button pressed");
                            Navigator.pushNamed(context, RouteNames.loginScreen);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              //color: oBlack,
                              border: Border.all(width: 1, color: oWhite),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  height: 35,
                                  width: 35,
                                  decoration: const BoxDecoration(
                                    color: oWhite,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: oBlack,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  "Get Started".toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: oWhite,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(width: 15),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ),
          ],
        ),

      ),
    );
  }
}
