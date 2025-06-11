
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../forms/users/user_create_form.dart';
import '../../../../forms/users/users_edit_form.dart';
import '../../../../models/users_model.dart';
import '../../../../services/api.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/logger.dart';
import '../../../../utils/routes/route_names.dart';
import '../../../widgets/alert_dialog_themes/create_alert_dialog.dart';
import '../../../widgets/alert_dialog_themes/delete_alert_dialog.dart';
import '../../../widgets/alert_dialog_themes/edit_alert_dialog.dart';
import '../../../widgets/alert_dialog_themes/error_alert_dialog.dart';
import '../../../widgets/custom_datatable_theme.dart';
import '../../../widgets/custom_pagination.dart';
import '../../overview/widgets/appbar.dart';
import '../../overview/widgets/side_bar.dart';

class UsersDesktopUi extends StatefulWidget {
  const UsersDesktopUi({super.key});

  @override
  State<UsersDesktopUi> createState() => _UsersDesktopUiState();
}

class _UsersDesktopUiState extends State<UsersDesktopUi> {
  final ScrollController _dataScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final int _rowsPerPage = 8;
  int _currentPage = 1;
  List<User> users = [];
  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.get(
        Uri.parse(BaseURLConfig.usersApiURL),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        LoggerUtil.getInstance.print("GET USERS:\n$responseData");

        List<User> fetchedUsers = (responseData as List)
            .map<User>((json) => User.fromJson(json))
            .toList();

        setState(() {
          users = fetchedUsers;
          _filteredUsers = fetchedUsers;
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      LoggerUtil.getInstance.print("Error fetching data: \n$e");
    }
  }

  Future<void> createUser(
      String name,
      String emailID,
      String userName,
      String password,
      String userRole,
      String userPhoneNumber,
      int userCommunity,
      BuildContext context,
      ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.post(
        Uri.parse(BaseURLConfig.usersApiURL),
        body: jsonEncode({
          "name": name,
          "email": emailID,
          "username": userName,
          "password": password,
          "role": userRole,
          "phone_number": userPhoneNumber,
          "organization_id": userCommunity,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = response.body;
        LoggerUtil.getInstance.print("json CREATE USERS:\n$json");

        Navigator.pop(context); // Close the dialog here

        showCreateAlertDialog(
            context, 'User Creation!', 'Successfully created the user', true);
        fetchData();
      } else {
        final json = response.body;
        Map<String, dynamic> map = jsonDecode(json);
        LoggerUtil.getInstance.print("Server Response Data>>>${map['data']}");
        showErrorAlertDialog(context, 'User Creation!', map['data'], false);
      }
    } catch (e) {
      LoggerUtil.getInstance.print("Error creating user: \n$e");
    }
  }

  Future<void> editUser(
      int userId,
      String name,
      String emailID,
      String userName,
      String password,
      String userRole,
      String userPhoneNumber,
      int userCommunity,
      BuildContext context,
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.put(
      Uri.parse('${BaseURLConfig.usersApiURL}/$userId'),
      body: jsonEncode({
        "name": name,
        "email": emailID,
        "username": userName,
        "password": password,
        "role": userRole,
        "phone_number": userPhoneNumber,
        "organization_id": userCommunity,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = response.body;
      LoggerUtil.getInstance.print("json EDIT USERS:\n$json");

      Navigator.pop(context); // Close the dialog here
      showEditAlertDialog(context, 'User Updation!', 'Successfully updated the user', true);
      fetchData();
    } else {
      print("Error: ${response.statusCode}");
      print("Response body: ${response.body}");

      try {
        final json = response.body;
        Map<String, dynamic> map = jsonDecode(json);
        print("Server Response Data>>>${map['data']}");
        showErrorAlertDialog(context, 'User Updation!', map['data'], false);
      } catch (e) {
        showErrorAlertDialog(context, 'User Updation!', 'Unexpected error occurred', false);
      }
    }
  }



  Future<void> deleteUser(String userId) async {
    print("Delete user>>>userId>>>>" + userId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.delete(
        Uri.parse('${BaseURLConfig.usersApiURL}/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Delete user>>>ResponseBody>>>>" + response.body);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final json = response.body;
          Map<String, dynamic> map = jsonDecode(json);
          //print("Server Response Data>>>${map['data']}");
          showDeleteAlertDialog(
              context, 'User Deletion!', 'Successfully deleted the user', true);
          fetchData();
        } else {
          print("Empty response body");
        }
      } else {
        final json = response.body;
        Map<String, dynamic> map = jsonDecode(json);
        print("Server Response Data>>>${map['data']}");
        showErrorAlertDialog(context, 'User Deletion!', map['data'], false);
      }
    } catch (e) {
      print("Error during HTTP request: $e");
    }
  }

  void _filterUsers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = users.where((user) {
        return user.userId.toString().toLowerCase().contains(query) ||
            user.name!.toLowerCase().contains(query) ||
            user.username!.toLowerCase().contains(query) ||
            user.email!.toLowerCase().contains(query) ||
            user.role!.toLowerCase().contains(query);
      }).toList();
    });
  }

  List<User> _getPaginatedUsers() {
    int startIndex = (_currentPage - 1) * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    endIndex = endIndex > _filteredUsers.length ? _filteredUsers.length : endIndex;
    return _filteredUsers.sublist(startIndex, endIndex);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  List<DataRow> getCurrentPageRows() {
    List<User> currentPageUsers = _getPaginatedUsers();
    return currentPageUsers.asMap().entries.map((entry) {
      final index = entry.key;
      final user = entry.value;
      return DataRow(cells: [
        DataCell(Text('${index + 1 + (_currentPage - 1) * _rowsPerPage}', style: DataCellTextStyle)),
        DataCell(Text(user.userId.toString().padLeft(5, '0'), style: DataCellTextStyle)),
        DataCell(Text(user.username!, style: DataCellTextStyle)),
        DataCell(Text(user.name!, style: DataCellTextStyle)),
        DataCell(Text(user.email!, style: DataCellTextStyle)),
        DataCell(Text(user.organizationName! ?? '', style: DataCellTextStyle)),
        DataCell(Text(user.role!, style: DataCellTextStyle)),
        DataCell(Text(user.phoneNumber ?? "", style: DataCellTextStyle)),
        DataCell(Row(
          children: [
            Tooltip(
                message: "Edit",
                textStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  color: oWhite,
                ),
                child: IconButton(
                  onPressed: () {
                    _editUser(context, user);
                  },
                  icon: SvgPicture.asset(
                    'icons/edit.svg',
                    color: oBlue,
                    width: 20.0,
                    height: 20.0,
                  ),
                )
            ),
            const SizedBox(width: 2),
            Tooltip(
                message: "Delete",
                textStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  color: oWhite,
                ),
                child: IconButton(
                  onPressed: () {
                    _deleteUser(user);
                  },
                  icon: SvgPicture.asset(
                    'icons/delete.svg',
                    color: oRed,
                    width: 20.0,
                    height: 20.0,
                  ),
                )
            ),
          ],
        )),
      ]);
    }).toList();
  }

  void _createUser(BuildContext context) async {
    final create_user = User(
      name: '',
      email: '',
      passwordHash: '',
      role: '',
      username: '',
      phoneNumber: '',
      organizationId: 1,
    );
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController create_userNameController =
    TextEditingController();
    final TextEditingController create_passwordController =
    TextEditingController();
    final TextEditingController create_nameController = TextEditingController();
    final TextEditingController create_emailController =
    TextEditingController();
    final TextEditingController create_phoneNumberController =
    TextEditingController();

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          elevation: 0,
          backgroundColor: oWhite,

          child: Container(
            width: MediaQuery.of(context).size.width * 0.55,
            height: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
                color: oWhite,
                borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                      child: Lottie.asset(
                          "animations/user.json",
                          width: 250
                      )
                  ),
                ),
                Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("User Creation",
                          style: GoogleFonts.poppins(
                              color: oBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        // const SizedBox(height: 10,),
                        CreateUserFormScreen(
                          formKey: _formKey,
                          userNameController: create_userNameController,
                          passwordController: create_passwordController,
                          nameController: create_nameController,
                          emailController: create_emailController,
                          phoneNumberController: create_phoneNumberController,
                          user: create_user,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, right: 35),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    oRed.withOpacity(0.1),
                                  ),
                                  side: MaterialStateProperty.resolveWith<BorderSide>(
                                        (Set<MaterialState> states) {
                                      return BorderSide(color: oRed.withOpacity(0.1));
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  // padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  //   const EdgeInsets.symmetric(
                                  //     horizontal: 10,
                                  //     vertical: 5,
                                  //   ),
                                  // ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.poppins(
                                    color: oRed,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    create_user.username = create_userNameController.text;
                                    create_user.passwordHash = create_passwordController.text;
                                    create_user.name = create_nameController.text;
                                    create_user.email = create_emailController.text;
                                    create_user.role = create_user.role;
                                    create_user.phoneNumber = create_phoneNumberController.text;
                                    create_user.organizationId = create_user.organizationId;

                                    await createUser(
                                      create_user.name!,
                                      create_user.email!,
                                      create_user.username!,
                                      create_user.passwordHash!,
                                      create_user.role!,
                                      create_user.phoneNumber!,
                                      create_user.organizationId!,
                                      dialogContext,
                                    );

                                    // Navigator.pop(dialogContext);
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    oGreen.withOpacity(0.1),
                                  ),
                                  side: MaterialStateProperty.resolveWith<BorderSide>(
                                        (Set<MaterialState> states) {
                                      return BorderSide(color: oGreen.withOpacity(0.1));
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Create',
                                  style: GoogleFonts.poppins(
                                    color: oGreen,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )

                      ],
                    )
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _editUser(BuildContext context, User user) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController edit_userNameController = TextEditingController();
    final TextEditingController edit_passwordController = TextEditingController();
    final TextEditingController edit_nameController = TextEditingController();
    final TextEditingController edit_emailController = TextEditingController();
    final TextEditingController edit_phoneNumberController = TextEditingController();
    final TextEditingController edit_userRoleController = TextEditingController();

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          elevation: 0,
          backgroundColor: oWhite,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.55,
            height: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              color: oWhite,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Lottie.asset("animations/edit.json", width: 250),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "User Updation",
                        style: GoogleFonts.poppins(
                          color: oBlack,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      EditUserFormScreen(
                        formKey: _formKey,
                        userNameController: edit_userNameController,
                        passwordController: edit_passwordController,
                        nameController: edit_nameController,
                        emailController: edit_emailController,
                        userRoleController: edit_userRoleController,
                        phoneNumberController: edit_phoneNumberController,
                        user: user,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  oRed.withOpacity(0.1),
                                ),
                                side: MaterialStateProperty.resolveWith<BorderSide>(
                                      (Set<MaterialState> states) {
                                    return BorderSide(color: oRed.withOpacity(0.1));
                                  },
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                  color: oRed,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Ensure user.userId is not null before converting to String
                                  if (user.userId != null) {
                                    editUser(
                                      user.userId!,
                                      edit_nameController.text,
                                      edit_emailController.text,
                                      edit_userNameController.text,
                                      edit_passwordController.text,
                                      user.role!,
                                      edit_phoneNumberController.text,
                                      user.organizationId!,
                                      context,
                                    );
                                  } else {
                                    // Handle the case where user.userId is null
                                    print('User ID is null');
                                  }
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  oGreen.withOpacity(0.1),
                                ),
                                side: MaterialStateProperty.resolveWith<BorderSide>(
                                      (Set<MaterialState> states) {
                                    return BorderSide(color: oGreen.withOpacity(0.1));
                                  },
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Save',
                                style: GoogleFonts.poppins(
                                  color: oGreen,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteUser(User user) async {
    final response = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: oWhite,
          title: Text(
            'Delete User',
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${user.name}?',
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  oRed.withOpacity(0.1),
                ),
                side: MaterialStateProperty.resolveWith<BorderSide>(
                      (Set<MaterialState> states) {
                    return BorderSide(color: oRed.withOpacity(0.1));
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                ),
              ),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: oRed,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  oGreen.withOpacity(0.1),
                ),
                side: MaterialStateProperty.resolveWith<BorderSide>(
                      (Set<MaterialState> states) {
                    return BorderSide(color: oGreen.withOpacity(0.1));
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                ),
              ),
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: oGreen,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (response == true) {
      await deleteUser(user.userId.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: SideBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 15),
        child: Column(
          children: [
            const ScreenAppBar(),
            const SizedBox(height: 15),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              LoggerUtil.getInstance.print("Home button pressed");
                              Navigator.pushNamed(context, RouteNames.homeScreen);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.home,
                                  size: 16,
                                  color: oBlack.withOpacity(0.5),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Home",
                                  style: GoogleFonts.poppins(
                                    color: oBlack.withOpacity(0.5),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            " / Users",
                            style: GoogleFonts.poppins(
                              color: oBlack,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 300,
                            height: 40,
                            decoration: BoxDecoration(
                              //color: oWhite,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 0.5, color: oBlack)
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Center(
                              child: TextFormField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  hintStyle: GoogleFonts.poppins(
                                    color: oBlack.withOpacity(0.7),
                                    fontSize: 13,
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(CupertinoIcons.search, color: oBlack.withOpacity(0.7),size: 18,),
                                ),
                                style: GoogleFonts.poppins(
                                  color: oBlack,
                                  fontSize: 13,
                                ),
                                cursorColor: oBlack,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          TextButton(
                            onPressed: () {
                              LoggerUtil.getInstance.print("Add user button pressed");
                              _createUser(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(oBlack),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              fixedSize: MaterialStateProperty.all(const Size(110, 40)),
                            ),
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.add, size: 18, color: oWhite,),
                                const SizedBox(width: 5,),
                                Text(
                                  "Add User",
                                  style: GoogleFonts.poppins(
                                    color: oWhite,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Expanded(
                    child: _buildTable(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: CustomPagination(
                totalItems: _filteredUsers.length,
                rowsPerPage: _rowsPerPage,
                onPageChanged: _onPageChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<String> userAvatar = [
    "icons/leaf1.svg",
    "icons/leaf2.svg",
    "icons/leaf4.svg",
    "icons/leaf5.svg",
    "icons/leaf6.svg",
    "icons/leaf7.svg",
    "icons/leaf8.svg",
    "icons/leaf7.svg",
  ];

  String getRandomAvatar() {
    final random = Random();
    return userAvatar[random.nextInt(userAvatar.length)];
  }

  Widget _buildTable() {
    return Table(
      border: TableBorder(
        top: BorderSide(color: oBlack.withOpacity(0.5), width: 0.5),
        left: BorderSide(color: oBlack.withOpacity(0.5), width: 0.5),
        right: BorderSide(color: oBlack.withOpacity(0.5), width: 0.5),
        bottom: BorderSide(color: oBlack.withOpacity(0.5), width: 0.5),
        horizontalInside: const BorderSide(
          color: oBlack, // Row-dividing line color
          width: 0.1,
        ),
      ),
      columnWidths: const {
        0: FixedColumnWidth(50),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(3),
        4: FlexColumnWidth(2),
        5: FlexColumnWidth(2),
        6: FlexColumnWidth(2),
        7: FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Table Header
        TableRow(
          //decoration: BoxDecoration(color: oBlack),
          children: [
            _buildTableCell('S.No', isHeader: true),
            _buildTableCell('Username', isHeader: true),
            _buildTableCell('Name', isHeader: true),
            _buildTableCell('Email', isHeader: true),
            _buildTableCell('Community', isHeader: true),
            _buildTableCell('Role', isHeader: true),
            _buildTableCell('Mobile', isHeader: true),
            _buildTableCell('Actions', isHeader: true),

          ],
        ),
        // Table Rows
        ..._getPaginatedUsers().asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;
          return TableRow(
            // decoration: BoxDecoration(
            //   color: index.isEven ? Colors.white : Colors.grey[100],
            // ),
            children: [
              _buildTableCell('${index + 1 + (_currentPage - 1) * _rowsPerPage}'),
              //_buildTableCell(user.username!),
              _buildUsernameCell(user.username!, getRandomAvatar()),
              _buildTableCell(user.name!),
              _buildTableCell(user.email!),
              _buildTableCell(user.organizationName!),
              _buildTableCell(user.role!),
              _buildTableCell(user.phoneNumber!),
              _buildActionCell(context, user),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildUsernameCell(String username, String? svgAssetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        children: [
          // Avatar
          if (svgAssetPath != null && svgAssetPath.isNotEmpty)
            ClipOval(
              child: SizedBox(
                width: 30,
                height: 30,
                child: SvgPicture.asset(
                  svgAssetPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(width: 8), // Spacing between avatar and text
          // Username
          Expanded(
            child: Text(
              username,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: oBlack,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String content, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        content,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: oBlack,
        ),
        //textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionCell(BuildContext context, User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: SvgPicture.asset(
            'icons/edit.svg',
            color: oBlue,
            width: 20.0,
            height: 20.0,
          ),
          onPressed: () => _editUser(context, user),
        ),
        IconButton(
          icon: SvgPicture.asset(
            'icons/delete.svg',
            color: oRed,
            width: 20.0,
            height: 20.0,
          ),
          onPressed: () => _deleteUser(user),
        ),
      ],
    );
  }
}
