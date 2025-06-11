import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/logger.dart';
import '../../../../utils/routes/route_names.dart';
import '../../overview/widgets/appbar.dart';
import '../../overview/widgets/side_bar.dart';

class SettingsDesktopUi extends StatefulWidget {
  const SettingsDesktopUi({super.key});

  @override
  State<SettingsDesktopUi> createState() => _SettingsDesktopUiState();
}

class _SettingsDesktopUiState extends State<SettingsDesktopUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: oWhite,
        drawer: const Drawer(
          child: SideBar(),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 15),
          child: Column(
            children: [
              const ScreenAppBar(),
              const SizedBox(height: 15),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                LoggerUtil.getInstance.print("Home button pressed");
                                Navigator.pushNamed(context, RouteNames.homeScreen);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.home,
                                    size: 16,
                                    color: oBlack.withOpacity(0.5),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Home",
                                    style: GoogleFonts.poppins(
                                      color: oBlack.withOpacity(0.5),
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              " / Settings",
                              style: GoogleFonts.poppins(
                                color: oBlack,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                    const SizedBox(height: 20),

                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
