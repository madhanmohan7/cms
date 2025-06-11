import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/colors/colors.dart';

class FooterSection extends StatefulWidget {
  const FooterSection({super.key});

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width * 0.25,
      decoration: const BoxDecoration(
        color: oBlack,
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.18),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: oTransparent,
                  ),
                  child: Center(
                    child: Text(
                      '"Our portal provides you with the easiest way to find and use charging stations. '
                          'You can now charge your vehicle without any hassle and enjoy a seamless experience. '
                          'Join us and take advantage of our extensive network of charging stations and user-friendly interface."',
                      style: GoogleFonts.poppins(
                        color: oWhite,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Spacer(),
                const Image(
                  image: AssetImage("icons/ocpp.png"),
                  width: 90,
                  height: 90,
                ),
                const SizedBox(width: 25,),
                const Image(
                  image: AssetImage("icons/ocpi.png"),
                  width: 80,
                  height: 80,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OCPP CMS Company',
                    style: GoogleFonts.poppins(
                      color: oWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '• Fast charging stations across the country.\n'
                        '• Efficient and eco-friendly EV charging points.\n'
                        '• 24/7 support for all your EV charging needs.\n'
                        '• Dedicated mobile app for locating and booking charging stations.',
                    style: GoogleFonts.poppins(
                      color: oWhite,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Head Office Address',
                        style:  GoogleFonts.poppins(
                          color: oWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Infiquity Auto Technologies Pvt Ltd\n'
                            'NS Palya, RR Heights, # 12, 1st Floor\n'
                            'Bannerghatta Main Rd, Industrial Area\n'
                            'Bengaluru, Karnataka,\n'
                            'India  560076',
                        style:  GoogleFonts.poppins(
                          color: oWhite,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UK Office Address',
                        style:  GoogleFonts.poppins(
                          color: oWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Infiquity UK Limited.\n'
                            'Innovation Centre,\n'
                            'Gallows Hill, Warwick,\n'
                            'United Kingdom,CV34 6UW.\n'
                            'Tel : + 0044-1926-217862',
                        style:  GoogleFonts.poppins(
                          color: oWhite,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )

                ],
              )
            ],
          ),

          const Spacer(), // Push copyright to the bottom

          const Divider(
            color: oWhite,
            thickness: 1,
            // indent: 40,
            // endIndent: 40,
          ),
          // Copyright Notice
          Align(
            alignment: Alignment.center,
            child: Text(
              '© 2024 OCPP CMS Company. All rights reserved.',
              style: GoogleFonts.poppins(
                color: oWhite,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
