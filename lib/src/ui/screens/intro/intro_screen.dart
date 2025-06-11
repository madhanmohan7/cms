import 'package:flutter/material.dart';

import '../../../utils/responsive/responsive_layout.dart';
import 'screen_sizes/desktop.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ResponsiveBuilder(
            mobile: (context, constraints) {
              return Container();
            },
            tablet: (context, constraints) {
              return Container();
            },
            desktop: (context, constraints) {
              return const IntroDesktopUi();
            },
          )
      ),
    );
  }

}
