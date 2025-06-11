import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../models/billings_model.dart';
import '../../../../models/chargers_model.dart';
import '../../../../models/commuinities_model.dart';
import '../../../../models/users_model.dart';
import '../../../../services/api.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/logger.dart';

class multiStatsCards extends StatefulWidget {

  const multiStatsCards({
    super.key
  });

  @override
  State<multiStatsCards> createState() => _multiStatsCardsState();
}

class _multiStatsCardsState extends State<multiStatsCards> {

  int energyConsumed = 0; // store the energy consumed value
  int completedBookingsCount = 0;
  bool isLoading = false;

  List<User> users = [];
  List<Communities> communities = [];

  List<Charger> chargers = [];
  List<Billings> billings = [];


  @override
  void initState() {
    super.initState();
    fetchUsersDataLength();
    fetchCommunitiesDataLength();
    fetchChargersDataLength();
    fetchBookingsData();
  }

  Future<void> fetchUsersDataLength() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(BaseURLConfig.usersApiURL),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      LoggerUtil.getInstance.print("responseData: \n$responseData");

      List<User> fetchedUsers =
      responseData.map<User>((json) => User.fromJson(json)).toList();

      setState(() {
        users = fetchedUsers;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> fetchCommunitiesDataLength() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(BaseURLConfig.communitiesApiURL),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      LoggerUtil.getInstance.print("responseData: \n$responseData");

      List<Communities> fetchedCommunities =
      responseData.map<Communities>((json) => Communities.fromJson(json)).toList();

      setState(() {
        communities = fetchedCommunities;
      });
    } else {
      throw Exception('Failed to load communities');
    }
  }

  Future<void> fetchChargersDataLength() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.get(
        Uri.parse(BaseURLConfig.chargersApiURL),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        LoggerUtil.getInstance.print("GET Chargers:\n$responseData");

        List<Charger> fetchedChargers = (responseData as List)
            .map<Charger>((json) => Charger.fromJson(json))
            .toList();

        setState(() {
          chargers = fetchedChargers;
        });
      } else {
        throw Exception('Failed to load Chargers');
      }
    } catch (e) {
      LoggerUtil.getInstance.print("Error fetching data: \n$e");
    }
  }

  Future<void> fetchBookingsData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.get(
        Uri.parse(BaseURLConfig.billingsApiURL),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        LoggerUtil.getInstance.print("GET Billings:\n$responseData");

        List<Billings> fetchedBillings = (responseData as List)
            .map<Billings>((json) => Billings.fromJson(json))
            .toList();

        // Filter and get the completed bookings count
        int completedCount = fetchedBillings
            .where((billing) => billing.status!.toLowerCase() == "completed")
            .length;

        setState(() {
          billings = fetchedBillings;
          completedBookingsCount = completedCount;
        });
      } else {
        throw Exception('Failed to load billings');
      }

    } catch (e) {
      LoggerUtil.getInstance.print("Error fetching data: \n$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Charger> operativeChargers = chargers.where((charger) => charger.status == 'Operative').toList();
    List<Charger> inOperativeChargers = chargers.where((charger) => charger.status == 'Inoperative').toList();

    return Row(
      children: [
        _buildCard(225, 150, oBlue, users.length, 'Users', 'icons/users.svg'),
        const SizedBox(width: 15,),
        _buildCard(175, 150, oOrange, communities.length, 'Communities', 'icons/org.svg'),
        const SizedBox(width: 15,),
        _buildCard(175, 150, oGreen, operativeChargers.length, 'Active Chargers', 'icons/charger.svg'),
        const SizedBox(width: 15,),
        _buildCard(175, 150, oRed, inOperativeChargers.length, 'InActive Chargers', 'icons/charger.svg'),
        const SizedBox(width: 15,),
        _buildCard(250, 150, oPink, billings.length, 'Total Bookings', 'icons/chsession.svg'),
        const SizedBox(width: 15,),
        _buildCard(250, 150, oBlueSky, completedBookingsCount, 'Completed Bookings', 'icons/chsession.svg'),
      ],
    );
  }

  Widget _buildCard(
      double width,
      double height,
      Color svgBgColor,
      int value,
      String label,
      String svgAssetPath, // New parameter for dynamic SVG path
      ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: oWhite,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: oBlack.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ]
      ),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: svgBgColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(15),
            child: SvgPicture.asset(
              svgAssetPath, // Use the dynamic SVG path here
              color: svgBgColor,
              width: 30.0,
              height: 30.0,
            ),
          ),
          Text(
            '$value',
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

}
