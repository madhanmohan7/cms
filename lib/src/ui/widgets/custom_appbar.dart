import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors/colors.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback onContactUsPressed;
  final VoidCallback onServicesPressed;
  final VoidCallback onPricingPressed;
  final VoidCallback onAboutUsPressed;

  const CustomAppBar({
    super.key,
    required this.onContactUsPressed,
    required this.onServicesPressed,
    required this.onPricingPressed,
    required this.onAboutUsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'icons/ev_leaf.svg',
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CMS',
                    style: GoogleFonts.goldman(
                      color: oBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    'Charger Management System',
                    style: GoogleFonts.goldman(
                        color: oBlack,
                        fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _buildHoverButton('Products'),
              _buildHoverButton('Services', onTap: onServicesPressed),
              _buildHoverButton('Pricing', onTap: onPricingPressed),
              _buildHoverButton('About Us', onTap: onAboutUsPressed),
              _buildHoverButton('Contact Us', onTap: onContactUsPressed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHoverButton(String text, {VoidCallback? onTap}) {
    return MouseRegion(
      onEnter: (_) {
        // Perform any hover effect here
      },
      onExit: (_) {
        // Remove hover effect here
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextButton(
          onPressed: onTap,
          style: ButtonStyle(
            //backgroundColor: MaterialStateProperty.all(oBlack.withOpacity(0.25)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(width: 0.5, color: oBlack)
              ),
            ),
            //minimumSize: MaterialStateProperty.all(const Size(100, 50)),
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 13,
              fontWeight: FontWeight.normal
            ),
          ),
        ),
      ),
    );
  }
}