import 'package:flutter/material.dart';

import '../../ui/screens/404/error404_screen.dart';
import '../../ui/screens/billings/billings_screen.dart';
import '../../ui/screens/chargers/chargers_screen.dart';
import '../../ui/screens/charging_sessions/chargingsession_screen.dart';
import '../../ui/screens/community/community_screen.dart';
import '../../ui/screens/home/home_screen.dart';
import '../../ui/screens/intro/intro_screen.dart';
import '../../ui/screens/login/login_screen.dart';
import '../../ui/screens/overview/overview_screen.dart';
import '../../ui/screens/settings/settings_screen.dart';
import '../../ui/screens/users/users_screen.dart';
import 'route_names.dart';

class _GeneratePageRoute extends PageRouteBuilder {
  final Widget widget;
  final String routeName;

  _GeneratePageRoute({
    required this.widget,
    required this.routeName
  })
      : super(
      settings: RouteSettings(name: routeName),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) {
        return SlideTransition(
          textDirection: TextDirection.rtl,
          position: Tween<Offset>(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      });
}


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.introScreen:
        return _GeneratePageRoute(
            widget: const IntroductionScreen(), routeName: settings.name!);
      case RouteNames.loginScreen:
        return _GeneratePageRoute(
            widget: const LoginScreen(), routeName: settings.name!);
      case RouteNames.homeScreen:
        return _GeneratePageRoute(
            widget: const HomeScreen(), routeName: settings.name!);
      case RouteNames.dashboardScreen:
        return _GeneratePageRoute(
            widget: const DashboardScreen(), routeName: settings.name!);
      case RouteNames.communitiesScreen:
        return _GeneratePageRoute(
            widget: const CommuitiesScreen(), routeName: settings.name!);
      case RouteNames.usersScreen:
        return _GeneratePageRoute(
            widget: const UsersScreen(), routeName: settings.name!);
      case RouteNames.chargersScreen:
        return _GeneratePageRoute(
            widget: const ChargersScreen(), routeName: settings.name!);
      case RouteNames.bookingsScreen:
        return _GeneratePageRoute(
            widget: const ChargingSessionScreen(), routeName: settings.name!);
      case RouteNames.billingsScreen:
        return _GeneratePageRoute(
            widget: const BillingsScreen(), routeName: settings.name!);
      case RouteNames.settingsScreen:
        return _GeneratePageRoute(
            widget: const SettingsScreen(), routeName: settings.name!);
      default:
        return _GeneratePageRoute(
            widget: const ErrorUnkownScreen(), routeName: settings.name!);
    }
  }
}