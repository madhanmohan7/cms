import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/logger.dart';
import '../../../../utils/routes/route_names.dart';
import '../widgets/analysis_card_chart.dart';
import '../widgets/appbar.dart';
import '../widgets/multi_stats_cards.dart';
import '../widgets/side_bar.dart';


class DashboardDesktopUi extends StatefulWidget {
  const DashboardDesktopUi({super.key});

  @override
  State<DashboardDesktopUi> createState() => _DashboardDesktopUiState();
}

class _DashboardDesktopUiState extends State<DashboardDesktopUi> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: SideBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 15),
        child: Column(
          children: [
            const ScreenAppBar(),
            const SizedBox(height: 15,),
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
                  ' / Overview',
                  style: GoogleFonts.poppins(
                    color: oBlack,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            const multiStatsCards(),
            const SizedBox(height: 15,),
            const analaysisCardAndChart()

          ],
        ),
      ),
    );
  }

}



