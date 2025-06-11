import 'package:flutter/material.dart';

import '../../../utils/responsive/responsive_layout.dart';

import 'screen_sizes/desktop.dart';

class ErrorUnkownScreen extends StatefulWidget {
  const ErrorUnkownScreen({super.key});

  @override
  State<ErrorUnkownScreen> createState() => _ErrorUnkownScreenState();
}

class _ErrorUnkownScreenState extends State<ErrorUnkownScreen> {
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
              return const ErrorUnkownDesktopUi();
            },
          )
      ),
    );
  }
}
