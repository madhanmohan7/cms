import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/colors/colors.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final List<Map<String, dynamic>> servicesData = [
    {
      'image': 'images/org1.jpg',
      'label': 'Gated Community',
      'services': [
        {
          'title': 'Shared Charging Stations',
          'points': [
            'Set up centralized charging stations in the community.',
            'Use RFID or mobile apps for authentication.',
          ],
        },
        {
          'title': 'Subscription Plans',
          'points': [
            'Monthly or yearly subscription for residents.',
            'Unlimited charging plans or pay-per-use.',
          ],
        },
        {
          'title': 'Energy Load Management',
          'points': [
            'Use smart load balancing to distribute power evenly across all charging stations.',
          ],
        },
        {
          'title': 'Integration with Solar Power',
          'points': [
            'Encourage the use of renewable energy by integrating solar panels to power the charging stations.',
          ],
        },
        {
          'title': 'Real-Time Status Monitoring',
          'points': [
            'Mobile app for residents to check charger availability and queue times.',
          ],
        },
        {
          'title': 'Booking System',
          'points': [
            'Allow residents to book charging slots in advance to avoid congestion.',
          ],
        },
      ],
    },
    {
      'image': 'images/mall.jpg',
      'label': 'Malls and Commercial Spaces',
      'services': [
        {
          'title': 'Fast Charging Stations',
          'points': [
            'Install DC fast chargers to cater to customers who want quick top-ups while shopping.',
          ],
        },
        {
          'title': 'EV Parking Integration',
          'points': [
            'Dedicate parking spots for EVs equipped with charging stations.',
          ],
        },
        {
          'title': 'Free Charging for Customers',
          'points': [
            'Offer free charging as a perk for customers who spend a minimum amount in the mall.',
          ],
        },
        {
          'title': 'Ad Revenue',
          'points': [
            'Use charging station displays for advertisements and generate additional revenue.',
          ],
        },
        {
          'title': 'Loyalty Programs',
          'points': [
            "Integrate with the mall's loyalty program to offer charging discounts to frequent shoppers.",
          ],
        },
        {
          'title': 'Analytics Dashboard',
          'points': [
            'Provide mall management with data on charger usage patterns and customer demographics.',
          ],
        },
      ],

    },
    {
      'image': 'images/company.jpg',
      'label': 'Company',
      'services': [
        {
          'title': 'Employee-Focused Charging',
          'points': [
            'Install EV chargers in office parking lots as an employee benefit.',
            'Allow employees to register their vehicles for free or subsidized charging.',
          ],
        },
        {
          'title': 'Fleet Management',
          'points': [
            'If the company uses electric fleet vehicles, provide specialized charging stations for fleet use.',
          ],
        },
        {
          'title': 'Time-Based Charging',
          'points': [
            'Limit charging sessions during peak hours to avoid excessive electricity costs.',
          ],
        },
        {
          'title': 'Workplace Energy Monitoring',
          'points': [
            'Offer companies insights into electricity usage and costs related to EV charging.',
          ],
        },
        {
          'title': 'Sustainability Reporting',
          'points': [
            'Help companies include EV charging as part of their corporate sustainability goals.',
          ],
        },
      ],
    },
    {
      'image': 'images/chsession.jpg',
      'label': 'Domestic',
      'services': [
        {
          'title': 'Individual Metering',
          'points': [
            'Install chargers with individual electricity metering for separate billing.',
          ],
        },
        {
          'title': 'Night-Time Charging Plans',
          'points': [
            'Offer discounted rates for night-time charging to balance electricity grid loads.',
          ],
        },
        {
          'title': 'Wi-Fi-Enabled Chargers',
          'points': [
            'Allow residents to monitor and control their chargers via mobile apps.',
          ],
        },
        {
          'title': 'Safety Features',
          'points': [
            'Include automatic shutoff and surge protection to ensure safety.',
          ],
        },
        {
          'title': 'Charger Sharing',
          'points': [
            'Enable charger sharing among residents with smart scheduling.',
          ],
        },
      ],
    },
    {
      'image': 'images/house.jpg',
      'label': 'House',
      'services': [
        {
          'title': 'Home Charging Solutions',
          'points': [
            'Provide installation services for Level 2 chargers at home.',
            'Offer portable charging units for convenience.',
          ],
        },
        {
          'title': 'Solar Panel Integration',
          'points': [
            'Help homeowners set up solar-powered EV chargers.',
          ],
        },
        {
          'title': 'Dynamic Load Management',
          'points': [
            'Prevent overloading the home’s electrical system with smart chargers that adjust the charging rate based on home energy usage.',
          ],
        },
        {
          'title': 'Energy Usage Insights',
          'points': [
            'Provide an app or dashboard for homeowners to track energy usage and costs.',
          ],
        },
        {
          'title': 'Warranty and Support',
          'points': [
            'Offer extended warranties and maintenance packages for home charging units.',
          ],
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "OUR SERVICES",
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Explore Our Popular Providing Services",
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...servicesData.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> service = entry.value;
            bool isImageFirst = index % 2 == 0; // Check if the index is even
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: _buildServiceCard(service, isImageFirst),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service, bool isImageFirst) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Centers all items vertically
      children: [
        if (isImageFirst)
          Flexible(
            flex: 2,
            child: _buildServiceImage(service['image'], service['label']),
          ),
        if (isImageFirst) const SizedBox(width: 30),
        Flexible(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: service.containsKey('services')
                ? service['services'].map<Widget>((serviceDetail) {
              return _buildServiceDes(
                serviceDetail['title'],
                serviceDetail['points'],
              );
            }).toList()
                : [],
          ),
        ),
        if (!isImageFirst) const SizedBox(width: 30),
        if (!isImageFirst)
          Flexible(
            flex: 2,
            child: _buildServiceImage(service['image'], service['label']),
          ),
      ],
    );
  }

  Widget _buildServiceImage(String asset, String serviceLabel) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(asset),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: oBlack.withOpacity(0.15),
            offset: const Offset(1, 1),
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: oBlack.withOpacity(0.4),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              serviceLabel,
              style: GoogleFonts.poppins(
                color: oWhite,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDes(String title, List<String> points) {
    return Container(
      //padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: oTransparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: oBlack,
            ),
          ),
          const SizedBox(height: 5),
          ...points.map((point) {
            return Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "• ",
                    style: TextStyle(fontSize: 14, color: oBlack),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: oBlack,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
