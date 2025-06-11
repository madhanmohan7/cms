import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.mobile,
    required this.tablet,
    required this.desktop,
    super.key,
  });

  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
  ) mobile;

  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
  ) tablet;

  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
  ) desktop;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 600;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop(context, constraints);
        } else if (constraints.maxWidth >= 600) {
          return tablet(context, constraints);
        } else {
          return mobile(context, constraints);
        }
      },
    );
  }
}
