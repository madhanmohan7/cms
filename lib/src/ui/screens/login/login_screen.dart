import 'package:flutter/material.dart';

import '../../../utils/responsive/responsive_layout.dart';
import 'screen_sizes/desktop.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              // Returning false to prevent going back
              return false;
            },
            child: ResponsiveBuilder(
              mobile: (context, constraints) {
                return Container();
              },
              tablet: (context, constraints) {
                return Container();
              },
              desktop: (context, constraints) {
                return const LoginDesktopUi();
              },
            ),
          )
      ),
    );
  }
}
