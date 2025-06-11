import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/routes/route_names.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int _selectedIndex = 0; // Track selected index
  String? userRole;

  final Map<int, String> _routeIndexMap = {
    0: RouteNames.dashboardScreen,
    1: RouteNames.communitiesScreen,
    2: RouteNames.usersScreen,
    3: RouteNames.chargersScreen,
    4: RouteNames.bookingsScreen,
    5: RouteNames.billingsScreen,
    6: RouteNames.dashboardScreen,
    7: RouteNames.settingsScreen,
  };

  Future<void> _userRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('userRole');
    setState(() {
      userRole = role;
    });
  }

  @override
  void initState() {
    super.initState();
    _userRole();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncSelectedIndexWithCurrentRoute();
  }

  void _syncSelectedIndexWithCurrentRoute() {
    // Determine the current route and update _selectedIndex
    String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    int index = _routeIndexMap.entries
        .firstWhere(
          (entry) => entry.value == currentRoute,
      orElse: () => const MapEntry(0, RouteNames.dashboardScreen),
    )
        .key;

    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: oWhite,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: ListView(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'icons/ev_leaf.svg',
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CMS',
                    style: GoogleFonts.goldman(
                      color: oBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Charger Management System',
                    style: GoogleFonts.goldman(
                      color: oBlack,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: oGrey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildUserRole("Admin"),
                _buildUserRole("Sub Admin"),
              ],
            ),
          ),
          const SizedBox(height: 15),
          _buildListItems(0, 'icons/dash.svg', 'Dashboard', RouteNames.dashboardScreen),
          if (userRole == "admin")
            _buildListItems(1, 'icons/org.svg', 'Communities', RouteNames.communitiesScreen),
          _buildListItems(2, 'icons/users.svg', 'Users', RouteNames.usersScreen),
          _buildListItems(3, 'icons/charger.svg', 'Chargers', RouteNames.chargersScreen),
          _buildListItems(4, 'icons/chsession.svg', 'Charging Session', RouteNames.bookingsScreen),
          _buildListItems(5, 'icons/bill.svg', 'Billings', RouteNames.billingsScreen),
          const SizedBox(height: 10),
          Divider(
            thickness: 1,
            color: oGrey.withOpacity(0.3),
            indent: 10,
            endIndent: 10,
          ),
          const SizedBox(height: 10),
          Text(
            'Account',
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          _buildListItems(6, 'icons/notify.svg', 'Notifications', RouteNames.dashboardScreen),
          _buildListItems(7, 'icons/settings.svg', 'Settings', RouteNames.settingsScreen),
        ],
      ),
    );
  }

  Widget _buildUserRole(String role) {
    bool isActive = role.toLowerCase().replaceAll(' ', '-') == userRole;

    return Container(
      width: 125,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? oGreen : oWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        role,
        style: GoogleFonts.poppins(
          color: isActive ? oWhite : oBlack,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildListItems(
      int index,
      String assetPath,
      String label,
      String routeName,
      ) {
    bool isSelected = _selectedIndex == index;
    return ListTile(
      leading: SvgPicture.asset(
        assetPath,
        width: 22,
        height: 22,
        color: isSelected ? oGreen : oBlack.withOpacity(0.6),
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          color: isSelected ? oGreen : oBlack.withOpacity(0.6),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        if (_selectedIndex != index) {
          setState(() {
            _selectedIndex = index;
          });

          Navigator.pushNamed(context, routeName);
        }
      },
    );
  }
}
