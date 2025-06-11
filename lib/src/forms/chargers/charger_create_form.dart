import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/chargers_model.dart';
import '../../models/commuinities_model.dart';
import '../../services/api.dart';
import '../../ui/widgets/custom_textfields.dart';
import '../../utils/colors/colors.dart';
import '../../utils/logger.dart';

class CreateChargerFormScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController stationIdController;
  final TextEditingController chargerStatusController;
  final Charger charger;

  const CreateChargerFormScreen({
    Key? key,
    required this.formKey,
    required this.stationIdController,
    required this.chargerStatusController,
    required this.charger,
  }) : super(key: key);

  @override
  _CreateChargerFormScreenState createState() => _CreateChargerFormScreenState();
}

class _CreateChargerFormScreenState extends State<CreateChargerFormScreen> {
  String? userRole;
  int? userCommunity;

  final List<String> pointTypes = ['Type 1', 'Type 2'];

  List<Communities> chargerCommunities = [];
  Communities? selectedCommunity;


  @override
  void initState() {
    super.initState();
    widget.stationIdController.text = widget.charger.stationId ?? '';
    //widget.chargerStatusController.text = widget.charger.status ?? 'Operative';
    widget.chargerStatusController.text = 'Operative';
    widget.charger.pointType = pointTypes[0];

    fetchChargerCommunities();
    _userRole();
    _userCommunity();
  }

  // Future<void> fetchUserCommunities() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('token');
  //     final response = await http.get(
  //       Uri.parse(BaseURLConfig.communitiesApiURL),
  //       headers: {'Authorization': 'Bearer $token'},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //
  //       LoggerUtil.getInstance.print("GET Communities:\n$responseData");
  //
  //       List<Communities> fetchedCommunities = (responseData as List)
  //           .map<Communities>((json) => Communities.fromJson(json))
  //           .toList();
  //
  //       setState(() {
  //         chargerCommunities = fetchedCommunities;
  //         // Set default community and organizationId
  //         widget.charger.organizationName = chargerCommunities[0].organizationName ?? '';
  //         widget.charger.organizationId = chargerCommunities[0].organizationId;
  //       });
  //     } else {
  //       throw Exception('Failed to load Communities');
  //     }
  //   } catch (e) {
  //     LoggerUtil.getInstance.print("Error fetching data: \n$e");
  //   }
  // }

  Future<void> fetchChargerCommunities() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.get(
        Uri.parse(BaseURLConfig.communitiesApiURL),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        LoggerUtil.getInstance.print("GET Communities:\n$responseData");

        List<Communities> fetchedCommunities = (responseData as List)
            .map<Communities>((json) => Communities.fromJson(json))
            .toList();

        if (mounted) {
          setState(() {
            chargerCommunities = fetchedCommunities;
            _filterCommunitiesBasedOnRole();
          });
        }
      } else {
        throw Exception('Failed to load Communities');
      }
    } catch (e) {
      LoggerUtil.getInstance.print("Error fetching data: \n$e");
    }
  }

  Future<void> _userRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('userRole');
    LoggerUtil.getInstance.print("Role $role");

    if (mounted) {
      setState(() {
        userRole = role;
        _filterCommunitiesBasedOnRole(); // Filter communities based on role
      });
    }
  }

  Future<void> _userCommunity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? community = prefs.getInt('userCommunity');
    LoggerUtil.getInstance.print("community $community");

    if (mounted) {
      setState(() {
        userCommunity = community;
        _filterCommunitiesBasedOnRole(); // Filter communities based on community
      });
    }
  }

  void _filterCommunitiesBasedOnRole() {
    if (userRole == "sub-admin" && userCommunity != null) {
      // Filter userCommunities to only show the sub-admin's assigned community
      final filteredCommunities = chargerCommunities
          .where((community) => community.organizationId == userCommunity)
          .toList();

      if (filteredCommunities.isNotEmpty) {
        setState(() {
          chargerCommunities = filteredCommunities;
          selectedCommunity = filteredCommunities.first;
          widget.charger.organizationName = selectedCommunity?.organizationName ?? '';
          widget.charger.organizationId = selectedCommunity?.organizationId;
        });
      }
    } else {
      setState(() {
        selectedCommunity = chargerCommunities.isNotEmpty ? chargerCommunities.first : null;
        widget.charger.organizationName = selectedCommunity?.organizationName ?? '';
        widget.charger.organizationId = selectedCommunity?.organizationId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      height: MediaQuery.of(context).size.width * 0.2,
      child: Scaffold(
        backgroundColor: oTransparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
              key: widget.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabeledMandatoryTextField(
                    label: 'OCPP Charger ID',
                    controller: widget.stationIdController,
                    validator: (value) {
                      if (!RegExp(r"^[a-zA-Z0-9\s]+$").hasMatch(value ?? '')) {
                        return 'Enter a valid charger id';
                      }
                      return null;
                    },
                    isMandatory: true,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownButton(
                          value: widget.charger.pointType!,
                          onChanged: (value) {
                            setState(() {
                              widget.charger.pointType = value!;
                            });
                          },
                          items: pointTypes.map((pointType) {
                            return DropdownMenuItem<String>(
                              value: pointType,
                              child: Text(pointType),
                            );
                          }).toList(),
                          labelText: 'Charger Point Type',
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Expanded(
                        child: _buildCommunityDropdown(
                          value: widget.charger.organizationName ?? '',
                          onChanged: userRole == "sub-admin" ? null : (community) {
                            setState(() {
                              widget.charger.organizationName = community?.organizationName ?? '';
                              widget.charger.organizationId = community?.organizationId ?? 0;
                            });
                          },
                          communities: chargerCommunities,
                        ),
                      ),
                    ],
                  ),

                  LabeledMandatoryTextField(
                    label: 'Charger Status',
                    controller: widget.chargerStatusController,
                    validator: (value) {
                      if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value ?? '')) {
                        return 'Enter a charger status';
                      }
                      return null;
                    },
                    isMandatory: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButton({
    required String value,
    required Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
    required String labelText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: labelText,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: oBlack,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' *',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: oRed,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField2<String>(
            value: value,
            onChanged: onChanged,
            items: items,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: oBlackOpacity, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: oBlackOpacity, width: 1),
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: oBlack,
              //fontWeight: FontWeight.bold,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: oBlack),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityDropdown({
    required String value,
    required Function(Communities?)? onChanged,
    required List<Communities> communities,
  }) {
    final isValidCommunity = communities.any((community) => community.organizationName == value);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Charger\'s Community',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: oBlack,
                  ),
                ),
                TextSpan(
                  text: ' *',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: oRed,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField2<Communities>(
            value: isValidCommunity
                ? communities.firstWhere((community) => community.organizationName == value)
                : null,
            onChanged: onChanged,
            items: communities.map((community) {
              return DropdownMenuItem<Communities>(
                value: community,
                child: Text(community.organizationName ?? ''),
              );
            }).toList(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: oBlackOpacity, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: oBlackOpacity, width: 1),
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: oBlack,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: oBlack),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
        ],
      ),
    );
  }

}
