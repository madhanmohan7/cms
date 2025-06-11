
import 'package:flutter/material.dart';

import '../../../utils/responsive/responsive_layout.dart';
import '../../../utils/routes/route_names.dart';
import '../../../utils/session_timeout/session_timeout.dart';

import '../logout/logout_config.dart';
import 'screen_sizes/desktop.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  late JwtExpirationHandler _jwtExpirationHandler;

  @override
  void initState() {
    super.initState();
    print('HomeScreen initialized');

    // Initialize JwtExpirationHandler
    _jwtExpirationHandler = JwtExpirationHandler(
      context: context,
      authService: AuthService(),
    );

    _jwtExpirationHandler.startTimer();
  }

  @override
  void dispose() {
    print('HomeScreen disposed');
    _jwtExpirationHandler.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              Navigator.pushNamed(context, RouteNames.homeScreen);
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
                return const DashboardDesktopUi();
              },
            ),
          )
      ),
    );
  }
}
