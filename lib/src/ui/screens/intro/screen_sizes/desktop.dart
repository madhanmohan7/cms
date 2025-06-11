import 'package:flutter/material.dart';

import '../../../widgets/custom_appbar.dart';

import '../widgets/about_us.dart';
import '../widgets/contact_us.dart';
import '../widgets/footer.dart';
import '../widgets/main_landing.dart';
import '../widgets/services.dart';
import '../widgets/subscription.dart';

class IntroDesktopUi extends StatefulWidget {
  const IntroDesktopUi({super.key});

  @override
  State<IntroDesktopUi> createState() => _IntroDesktopUiState();
}

class _IntroDesktopUiState extends State<IntroDesktopUi> {

  // GlobalKey to identify Sections
  final GlobalKey _contactUsKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _pricingKey = GlobalKey();
  final GlobalKey _aboutUsKey = GlobalKey();

  // scroll to Contact Us section
  void _scrollToContactUs() {
    Scrollable.ensureVisible(
      _contactUsKey.currentContext!,
      duration: const Duration(milliseconds: 500), // Smooth scroll
      curve: Curves.easeInOut,
    );
  }

  // scroll to Services section
  void _scrollToServices() {
    Scrollable.ensureVisible(
      _servicesKey.currentContext!,
      duration: const Duration(milliseconds: 500), // Smooth scroll
      curve: Curves.easeInOut,
    );
  }

  // scroll to Pricing section
  void _scrollToPricing() {
    Scrollable.ensureVisible(
      _pricingKey.currentContext!,
      duration: const Duration(milliseconds: 500), // Smooth scroll
      curve: Curves.easeInOut,
    );
  }

  // scroll to About Us section
  void _scrollToAboutUs() {
    Scrollable.ensureVisible(
      _aboutUsKey.currentContext!,
      duration: const Duration(milliseconds: 500), // Smooth scroll
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomAppBar(
                onContactUsPressed: _scrollToContactUs,
                onServicesPressed: _scrollToServices,
                onPricingPressed: _scrollToPricing,
                onAboutUsPressed: _scrollToAboutUs,
            ),
            const LandingSection(),
            const SizedBox(height: 25,),
            Services(key: _servicesKey),
            const SizedBox(height: 25,),
            SubscriptionPricing(key: _pricingKey),
            SizedBox(height: MediaQuery.of(context).size.width * 0.04,),
            AboutUs(key: _aboutUsKey),
            SizedBox(height: MediaQuery.of(context).size.width * 0.04,),
            ContactUsSection(key: _contactUsKey),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}

