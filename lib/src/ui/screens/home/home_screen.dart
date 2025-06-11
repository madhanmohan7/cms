import 'package:flutter/material.dart';

import '../../../utils/responsive/responsive_layout.dart';

import '../../../utils/session_timeout/session_timeout.dart';
import '../logout/logout_config.dart';
import 'screen_sizes/desktop.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        child:WillPopScope(
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
              return const HomeDesktopUi();
            },
          ),
        ),
      ),
    );
  }
}
