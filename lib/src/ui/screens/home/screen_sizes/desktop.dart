import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/logger.dart';
import '../../../../utils/routes/route_names.dart';
import '../widgets/appbar.dart';

class HomeDesktopUi extends StatefulWidget {
  const HomeDesktopUi({super.key});

  @override
  State<HomeDesktopUi> createState() => _HomeDesktopUiState();
}

class _HomeDesktopUiState extends State<HomeDesktopUi> {
  int _current = 0; // Track the current index of the centered item

  String dashText = "Overview".toUpperCase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Column(
          children: [
            const HomeCustomAppBar(),
            const SizedBox(height: 10,),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.21,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('images/bg1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: oBlack.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome To OCPP CMS Portal",
                            style: GoogleFonts.poppins(
                              color: oWhite,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '"Our portal provides you with the easiest way to find and use charging stations. '
                                'You can now charge your vehicle without any hassle and enjoy a seamless experience. '
                                'Join us and take advantage of our extensive network of charging stations and user-friendly interface."',
                            style: GoogleFonts.poppins(
                              color: oWhite,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          //const SizedBox(height: 10),
                          FittedBox(
                            child: InkWell(
                              onTap: () {
                                LoggerUtil.getInstance.print("dashboard navigation button pressed");
                                Navigator.pushNamed(context, RouteNames.dashboardScreen);
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
                                      padding: const EdgeInsets.all(6),
                                      height: 25,
                                      width: 25,
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
                                      'Go To "$dashText"',
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
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: CarouselSlider(
                      items: [
                        _buildContainer('images/stats1.jpg', 'Overview', 0),
                        _buildContainer('images/org1.jpg', 'Communities', 1),
                        _buildContainer('images/users.jpg', 'Users', 2),
                        _buildContainer('images/chsession.jpg', 'Charging\nSession', 3),
                        _buildContainer('images/charger1.jpg', 'Chargers', 4),
                        _buildContainer('images/bill1.jpg', 'Billings', 5),
                      ],
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.width * 0.18,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        viewportFraction: 0.3,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(String imagePath, String sliderText, int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _current == index ? oBlack.withOpacity(0.5) : oTransparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: _current == index
              ? Text(
            sliderText,
            style: GoogleFonts.poppins(
              color: oWhite,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          )
              : null,
        ),
      ),
    );
  }
}


