import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/colors/colors.dart';

class SubscriptionPricing extends StatefulWidget {
  const SubscriptionPricing({super.key});

  @override
  State<SubscriptionPricing> createState() => _SubscriptionPricingState();
}

class _SubscriptionPricingState extends State<SubscriptionPricing> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "OUR PRICING",
          style: GoogleFonts.poppins(
            color: oBlack,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Pricing & Packages",
          style: GoogleFonts.poppins(
            color: oBlack,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSubscription(
              "Basic Plan",
              "1250",
              "1 Year",
              "Perfect for individuals with light EV usage. "
                  "Includes access to shared charging stations. "
                  "No additional cost for maintenance. "
                  "Best for low-mileage EV owners. "
                  "24/7 customer support included.",
                  () {
                print("Basic Plan selected!");
              },
            ),
            const SizedBox(width: 20),
            _buildSubscription(
              "Beginner Plan",
              "2250",
              "2 Years",
              "Ideal for frequent EV users. "
                  "Includes access to priority charging slots. "
                  "Maintenance support included. "
                  "Supports up to 2 vehicles per user. "
                  "Mobile app integration available.",
                  () {
                print("Beginner Plan selected!");
              },
            ),
            const SizedBox(width: 20),
            _buildSubscription(
              "Pro Plan",
              "3550",
              "3 Years",
              "Designed for medium to large communities. "
                  "Unlimited charging access at partner locations. "
                  "Advanced real-time status monitoring. "
                  "Supports up to 5 vehicles per user. "
                  "Renewable energy integration optional.",
                  () {
                print("Pro Plan selected!");
              },
            ),
            const SizedBox(width: 20),
            _buildSubscription(
              "Premium Plan",
              "6750",
              "5 Years",
              "Tailored for large businesses and communities. "
                  "Smart load management included. "
                  "Comprehensive maintenance coverage. "
                  "Free installation of 2 charging stations."
                  " Solar energy support integration available.",
                  () {
                print("Premium Plan selected!");
              },
            ),
            const SizedBox(width: 20),
            _buildSubscription(
              "Ultimate Plan",
              "12550",
              "10 Years",
              "A complete EV charging solution for enterprises. "
                  "Unlimited charging across all partner stations. "
                  "Free installation of up to 5 stations. "
                  "Priority customer support 24/7. "
                  "Energy-efficient solutions with renewable options.",
                  () {
                print("Ultimate Plan selected!");
              },
            ),
          ],
        ),

      ],
    );
  }

  Widget _buildSubscription(
      String planTitle,
      String price,
      String plannedYears,
      String planDes,
      VoidCallback onPressedCallback,
      ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.18,
      height: 310,
      decoration: BoxDecoration(
        color: oWhite,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: oBlack.withOpacity(0.15),
            offset: const Offset(1, 1),
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between content
        children: [
          Column(
            children: [
              Text(
                planTitle,
                style: GoogleFonts.poppins(
                  color: oBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '₹ ', // Rupee symbol
                      style: GoogleFonts.poppins(
                        color: oBlack,
                        fontSize: 12, // Smaller font size for the symbol
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: price, // Price value
                      style: GoogleFonts.poppins(
                        color: oGreen,
                        fontSize: 35, // Larger font size for the price
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                plannedYears,
                style: GoogleFonts.poppins(
                  color: oBlack,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                planDes,
                style: GoogleFonts.poppins(
                  color: oBlack,
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          TextButton(
            onPressed: onPressedCallback,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                oTransparent,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              side: MaterialStateProperty.resolveWith<BorderSide>(
                    (Set<MaterialState> states) {
                  return const BorderSide(color: oGreen, width: 1);
                },
              ),
            ),
            child: Text(
              'Get Started',
              style: GoogleFonts.poppins(
                color: oGreen,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
