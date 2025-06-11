import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/commuinities_model.dart';
import '../../models/users_model.dart';
import '../../services/api.dart';
import '../../ui/widgets/custom_maxlen_textfields.dart';
import '../../ui/widgets/custom_textfields.dart';
import '../../utils/colors/colors.dart';
import '../../utils/logger.dart';

class EditUserFormScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController userNameController;
  final TextEditingController passwordController;
  final TextEditingController userRoleController;
  final TextEditingController phoneNumberController;
  final User user;

  const EditUserFormScreen({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.userNameController,
    required this.passwordController,
    required this.userRoleController,
    required this.phoneNumberController,
    required this.user,
  }) : super(key: key);

  @override
  _EditUserFormScreenState createState() => _EditUserFormScreenState();
}

class _EditUserFormScreenState extends State<EditUserFormScreen> {
  String? userRole;
  int? userCommunity;

  final List<String> userRoles = ['admin', 'sub-admin','user'];

  final List<String> subAdminRoles = ['sub-admin','user'];

  List<Communities> userCommunities = [];
  Communities? selectedCommunity;

  @override
  void initState() {
    super.initState();
    widget.nameController.text = widget.user.name ?? '';
    widget.emailController.text = widget.user.email ?? '';
    widget.userNameController.text = widget.user.username ?? '';
    widget.passwordController.text = widget.user.passwordHash ?? '';
    widget.userRoleController.text = widget.user.role ?? '';
    widget.phoneNumberController.text = widget.user.phoneNumber ?? '';

    //widget.user.role = userRoles[0];
    fetchUserCommunities();

    _userRole();
    _userCommunity();
  }

  Future<void> fetchUserCommunities() async {
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
            userCommunities = fetchedCommunities;
            _setSelectedCommunity(); // Set the initially selected community
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
      final filteredCommunities = userCommunities
          .where((community) => community.organizationId == userCommunity)
          .toList();

      if (filteredCommunities.isNotEmpty) {
        setState(() {
          userCommunities = filteredCommunities;
          _setSelectedCommunity();
        });
      }
    } else {
      _setSelectedCommunity();
    }
  }

  void _setSelectedCommunity() {
    // Set the initially selected community to the one already assigned to the charger
    selectedCommunity = userCommunities.firstWhere(
          (community) => community.organizationId == widget.user.organizationId,
      orElse: () => Communities(organizationId: 0, organizationName: null), // Provide a fallback Communities object
    );

    // If a valid community is found, update the charger's community
    if (selectedCommunity!.organizationId != 0) {
      setState(() {
        widget.user.organizationName = selectedCommunity!.organizationName ?? '';
        widget.user.organizationId = selectedCommunity!.organizationId;
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
                  Row(
                    children: [
                      Expanded(
                        child: LabeledMandatoryTextField(
                          label: 'Name',
                          controller: widget.nameController,
                          validator: (value) {
                            if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value ?? '')) {
                              return 'Enter a valid name with alphabets only';
                            }
                            return null;
                          },
                          isMandatory: true,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: LabeledMandatoryTextField(
                          label: 'Email ID',
                          controller: widget.emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            const pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            const specialCharPattern = r'^[a-zA-Z0-9_\-=@,.;]+$';
                            if (!RegExp(pattern).hasMatch(value ?? '')) {
                              return 'Enter a valid email address';
                            } else if (!RegExp(specialCharPattern)
                                .hasMatch(value.toString().split("@")[0] ?? '')) {
                              return 'Sorry, only letters(a-z or A-Z), numbers(0-9), and periods(.) are allowed.';
                            }
                            return null;
                          },
                          isMandatory: true,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LabeledMaxLengthTextField(
                          label: 'Phone Number',
                          controller: widget.phoneNumberController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator: (value) {
                            if (!RegExp(r'^(\+91|1)?[0-9]{10}$')
                                .hasMatch(value ?? '')) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                          isMandatory: true,
                        ),
                      ),
                      const SizedBox(width: 5),
                      // Expanded(
                      //   child: _buildDropdownButton(
                      //     value: widget.user.role!,
                      //     onChanged: (value) {
                      //       setState(() {
                      //         widget.user.role = value!;
                      //       });
                      //     },
                      //     items: userRoles.map((role) {
                      //       return DropdownMenuItem<String>(
                      //         value: role,
                      //         child: Text(role),
                      //       );
                      //     }).toList(),
                      //     labelText: 'User Role',
                      //   ),
                      // ),

                      Expanded(
                        child: userRole == "sub-admin"
                            ? _buildDropdownButton(
                          value: widget.user.role!,
                          onChanged: (value) {
                            setState(() {
                              widget.user.role = value!;
                            });
                          },
                          items: subAdminRoles.map((role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          labelText: 'User Role',
                        )
                            : _buildDropdownButton(
                          value: widget.user.role!,
                          onChanged: (value) {
                            setState(() {
                              widget.user.role = value!;
                            });
                          },
                          items: userRoles.map((role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          labelText: 'User Role',
                        ),
                      ),
                    ],
                  ),
                  // _buildCommunityDropdown(
                  //   value: widget.user.organizationName ?? '',
                  //   onChanged: (community) {
                  //     setState(() {
                  //       widget.user.organizationName = community?.organizationName ?? '';
                  //       widget.user.organizationId = community?.organizationId ?? 0;
                  //     });
                  //   },
                  //   communities: userCommunities,
                  // ),
                  _buildCommunityDropdown(
                    value: widget.user.organizationName ?? '',
                    onChanged: userRole == "sub-admin" ? null : (community) {
                      setState(() {
                        widget.user.organizationName = community?.organizationName ?? '';
                        widget.user.organizationId = community?.organizationId ?? 0;
                      });
                    },
                    communities: userCommunities,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LabeledMaxLengthTextField(
                          label: 'Username',
                          controller: widget.userNameController,
                          maxLength: 25,
                          validator: (value) {
                            if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value ?? '')) {
                              return 'Enter a valid username with alphabets only';
                            }
                            return null;
                          },
                          isMandatory: true,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: LabeledMandatoryTextField(
                          label: 'Password',
                          controller: widget.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            } else if (!RegExp(
                                r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).+$')
                                .hasMatch(value)) {
                              return 'Password must contain at least one uppercase, one lowercase, one digit and one special character';
                            } else if (value.toString().startsWith(" ")) {
                              return 'Password cannot start with a space';
                            }
                            return null;
                          },
                          isMandatory: true,
                        ),
                      ),
                    ],
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
    // Ensure that value is contained within items
    final isValidValue = items.any((item) => item.value == value);

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
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
          DropdownButtonFormField2<String>(
            value: isValidValue ? value : null, // Ensure value is valid
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
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'User\'s Community',
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
