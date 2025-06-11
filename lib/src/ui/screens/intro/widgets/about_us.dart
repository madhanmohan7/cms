import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/colors/colors.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'About Us',
              style: GoogleFonts.poppins(
                color: oBlack,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            'At EVCharge, we are dedicated to providing'
                ' seamless solutions for electric vehicle'
                ' (EV) charging management. Our platform is'
                ' designed to connect EV owners with reliable charging'
                ' stations, helping accelerate the transition to '
                'sustainable transportation.',
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15.0),
          Text(
            'Our Features:',
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10.0),
          // Feature Row 1
          Row(
            children: [
              Expanded(
                child: FeatureItem(
                  assetPath: 'icons/charger.svg',
                  title: 'Comprehensive EV Charger Locator',
                  description:
                  'Easily locate and navigate to the nearest EV charging stations.',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FeatureItem(
                  assetPath: 'icons/chsession.svg',
                  title: 'Real-Time Availability',
                  description:
                  'Get up-to-date information on charger availability and status.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          // Feature Row 2
          Row(
            children: [
              Expanded(
                child: FeatureItem(
                  assetPath: 'icons/card.svg',
                  title: 'Simple Payment Integration',
                  description:
                  'Enjoy hassle-free payments with multiple secure options.',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FeatureItem(
                  assetPath: 'icons/chart1.svg',
                  title: 'Usage Analytics',
                  description:
                  'Track your charging sessions and analyze energy consumption.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          Text(
            'Our Mission:',
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            'We aim to make EV ownership more '
                'convenient and accessible by offering '
                'user-friendly and reliable charging solutions. '
                'Together, we can drive towards a cleaner and greener future.',
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 25.0),
          Center(
            child: Text(
              'Thank you for choosing our eco!',
              style: GoogleFonts.poppins(
                color: oGreen,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String title;
  final String description;
  final String assetPath;

  const FeatureItem({
    super.key,
    required this.title,
    required this.description,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: oWhite,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: oBlack.withOpacity(0.15),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(1, 1),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: oWhite,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: oBlack.withOpacity(0.15),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(1, 1),
                )
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              assetPath,
              width: 25,
              height: 25,
              color: oGreen,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: oBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    color: oBlack,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
