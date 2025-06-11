import 'package:cmsweb/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';

import 'src/ui/screens/logout/logout_config.dart';
import 'src/utils/routes/route_names.dart';
import 'src/utils/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    AuthService();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),

      initialRoute: RouteNames.introScreen,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}