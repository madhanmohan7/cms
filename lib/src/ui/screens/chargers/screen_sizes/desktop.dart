import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../forms/chargers/charger_create_form.dart';
import '../../../../forms/chargers/charger_edit_form.dart';
import '../../../../models/chargers_model.dart';
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

class ChargersDesktopUi extends StatefulWidget {
  const ChargersDesktopUi({super.key});

  @override
  State<ChargersDesktopUi> createState() => _ChargersDesktopUiState();
}

class _ChargersDesktopUiState extends State<ChargersDesktopUi> {
  final ScrollController _dataScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final int _rowsPerPage = 8;
  int _currentPage = 1;
  List<Charger> chargers = [];
  List<Charger> _filteredChargers = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController.addListener(_filterChargers);
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
          _filteredChargers = fetchedChargers;
        });
      } else {
        throw Exception('Failed to load Chargers');
      }
    } catch (e) {
      LoggerUtil.getInstance.print("Error fetching data: \n$e");
    }
  }

  Future<void> createCharger(
      String stationId,
      String pointType,
      String chargerStatus,
      int chargerCommunity,
      BuildContext context,
      ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.post(
        Uri.parse(BaseURLConfig.chargersApiURL),
        body: jsonEncode({
          "station_id": stationId,
          "point_type": pointType,
          "status": chargerStatus,
          "organization_id": chargerCommunity,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = response.body;
        LoggerUtil.getInstance.print("json CREATE Chargers:\n$json");

        Navigator.pop(context); // Close the dialog here

        showCreateAlertDialog(
            context, 'Charger Creation!', 'Successfully created the charger', true);
        fetchData();
      } else {
        final Map<String, dynamic> json = jsonDecode(response.body);
        String errorMessage = json['error'] ?? 'Something went wrong';
        LoggerUtil.getInstance.print("json response : $json");

        showErrorAlertDialog(context, 'Charger Creation!', errorMessage, false);
      }
    } catch (e) {
      LoggerUtil.getInstance.print("Error creating charger: \n$e");
    }
  }

  Future<void> editCharger(
      int pointId,
      String stationId,
      String pointType,
      String chargerStatus,
      int chargerCommunity,
      BuildContext context,
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.put(
      Uri.parse('${BaseURLConfig.chargersApiURL}/$pointId'),
      body: jsonEncode({
        "station_id": stationId,
        "point_type": pointType,
        "status": chargerStatus,
        "organization_id": chargerCommunity,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = response.body;
      LoggerUtil.getInstance.print("json EDIT Chargers:\n$json");

      Navigator.pop(context); // Close the dialog here
      showEditAlertDialog(context, 'Charger Updation!', 'Successfully updated the Charger', true);
      fetchData();
    } else {
      print("Error: ${response.statusCode}");
      print("Response body: ${response.body}");

      try {
        final Map<String, dynamic> json = jsonDecode(response.body);
        String errorMessage = json['error'] ?? 'Something went wrong';
        LoggerUtil.getInstance.print("json response : $json");
        showErrorAlertDialog(context, 'Charger Updation!', errorMessage, false);
      } catch (e) {
        showErrorAlertDialog(context, 'Charger Updation!', 'Unexpected error occurred', false);
      }
    }
  }



  Future<void> deleteCharger(String pointId) async {
    print("Delete user>>>userId>>>>" + pointId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.delete(
        Uri.parse('${BaseURLConfig.chargersApiURL}/$pointId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Delete charger>>>ResponseBody>>>>" + response.body);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final json = response.body;
          Map<String, dynamic> map = jsonDecode(json);
          //print("Server Response Data>>>${map['data']}");
          showDeleteAlertDialog(
              context, 'Charger Deletion!', 'Successfully deleted the charger', true);
          fetchData();
        } else {
          print("Empty response body");
        }
      } else {
        final Map<String, dynamic> json = jsonDecode(response.body);
        String errorMessage = json['error'] ?? 'Something went wrong';
        LoggerUtil.getInstance.print("json response : $json");
        showErrorAlertDialog(context, 'Charger Deletion!', errorMessage, false);
      }
    } catch (e) {
      print("Error during HTTP request: $e");
    }
  }

  void _filterChargers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredChargers = chargers.where((charger) {
        return charger.pointId.toString().toLowerCase().contains(query) ||
            charger.stationId!.toLowerCase().contains(query) ||
            charger.pointType!.toLowerCase().contains(query) ||
            charger.status!.toLowerCase().contains(query);
      }).toList();
    });
  }

  List<Charger> _getPaginatedChargers() {
    int startIndex = (_currentPage - 1) * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    endIndex = endIndex > _filteredChargers.length ? _filteredChargers.length : endIndex;
    return _filteredChargers.sublist(startIndex, endIndex);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void onToggle(int index) async {
    setState(() {
      _filteredChargers[index].isOperative = !_filteredChargers[index].isOperative;
      _filteredChargers[index].status = _filteredChargers[index].isOperative ? "Operative" : "Inoperative"; // Update status text
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.put(
        Uri.parse('${BaseURLConfig.chargersApiURL}/${_filteredChargers[index].pointId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'is_operative': _filteredChargers[index].isOperative,
          'status': _filteredChargers[index].status,
        }),
      );

      if (response.statusCode == 200) {
        LoggerUtil.getInstance.print("Charger status updated successfully");
      } else {
        throw Exception('Failed to update Charger status');
      }
    } catch (e) {
      LoggerUtil.getInstance.print("Error updating charger status: \n$e");
    }
  }

  List<DataRow> getCurrentPageRows() {
    List<Charger> currentPageChargers = _getPaginatedChargers();
    return currentPageChargers.asMap().entries.map((entry) {
      final index = entry.key;
      final charger = entry.value;
      return DataRow(cells: [
        DataCell(Text('${index + 1 + (_currentPage - 1) * _rowsPerPage}', style: DataCellTextStyle)),
        //DataCell(Text(charger.pointId.toString().padLeft(3, '0'), style: DataCellTextStyle)),
        DataCell(Text(charger.stationId!, style: DataCellTextStyle)),
        DataCell(Text(charger.organizationName ?? "", style: DataCellTextStyle)),
        DataCell(Center(
          child: Switch(
            value: charger.isOperative,
            onChanged: (_) => onToggle(index),
            activeColor: oBlack,
            inactiveThumbColor: oGrey,
          ),
        )),
        //DataCell(Text(charger.status!, style: DataCellTextStyle)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: BoxDecoration(
              //color: charger.isOperative ? oGreen.withOpacity(0.2) : oRed.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 0.5, color: charger.isOperative ? oGreen : oRed)
            ),
            child: Text(
              charger.status!,
              style: GoogleFonts.poppins(
                color: charger.isOperative ? oGreen : oRed,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        DataCell(Center(child: Text(charger.pointType!, style: DataCellTextStyle))),
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
                    // Handle edit action
                    _editCharger(context, charger);
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
                    // Handle delete action
                    _deleteCharger(charger);
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

  void _createCharger(BuildContext context) async {
    final create_charger = Charger(
      stationId: '',
      pointType: '',
      status: '',
    );
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController createStationIdController =
    TextEditingController();
    final TextEditingController createStatusController = TextEditingController();

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
                  child: Center(child: Lottie.asset("animations/user.json", width: 250)),
                ),
                Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Charger Creation",
                          style: GoogleFonts.poppins(
                              color: oBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        // const SizedBox(height: 10,),
                        CreateChargerFormScreen(
                          formKey: _formKey,
                          stationIdController: createStationIdController,
                          chargerStatusController: createStatusController,
                          charger: create_charger,
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
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    create_charger.stationId = createStationIdController.text;
                                    create_charger.status = createStatusController.text;
                                    create_charger.pointType = create_charger.pointType;

                                    await createCharger(
                                      create_charger.stationId!,
                                      create_charger.pointType!,
                                      create_charger.status!,
                                      create_charger.organizationId!,
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

  void _editCharger(BuildContext context, Charger charger) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController editStationIdController =
    TextEditingController();
    final TextEditingController editStatusController = TextEditingController();

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
                        "Charger Updation",
                        style: GoogleFonts.poppins(
                          color: oBlack,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      EditChargerFormScreen(
                        formKey: _formKey,
                        stationIdController: editStationIdController,
                        chargerStatusController: editStatusController,
                        charger: charger,
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
                                  if (charger.pointId != null) {
                                    editCharger(
                                      charger.pointId!,
                                      editStationIdController.text,
                                      charger.pointType!,
                                      editStatusController.text,
                                      charger.organizationId!,
                                      context,
                                    );
                                  } else {
                                    // Handle the case where user.userId is null
                                    print('point ID is null');
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

  void _deleteCharger(Charger charger) async {
    final response = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: oWhite,
          title: Text(
            'Delete Charger',
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${charger.stationId}?',
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
      await deleteCharger(charger.pointId.toString());
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
            const SizedBox(height: 15,),
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
                              //Navigator.of(context).pop();
                            },
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.home, size: 16, color: oBlack.withOpacity(0.5),),
                                const SizedBox(width: 5,),
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
                          Text("/ Chargers",
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
                                  prefixIcon: Icon(CupertinoIcons.search, color: oBlack.withOpacity(0.7),),
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
                              LoggerUtil.getInstance.print("Add Charger button pressed");
                              _createCharger(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(oBlack),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              fixedSize: MaterialStateProperty.all(const Size(130, 40)),
                            ),
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.add, size: 16, color: oWhite,),
                                const SizedBox(width: 5,),
                                Text(
                                  "Add Charger",
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
              padding:
              const EdgeInsets.only(top: 10, bottom: 15),
              child: CustomPagination(
                totalItems: _filteredChargers.length,
                rowsPerPage: _rowsPerPage,
                onPageChanged: _onPageChanged,
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      controller: _dataScrollController,
      child: Column(
        children: [
          Table(
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
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FixedColumnWidth(150),
              4: FlexColumnWidth(),
              5: FlexColumnWidth(),
              6: FixedColumnWidth(100),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              // Table Header
              TableRow(
                //decoration: BoxDecoration(color: oBlack),
                children: [
                  _buildTableHeaderCell("S.No"),
                  _buildTableHeaderCell("Station ID"),
                  _buildTableHeaderCell("Organization Name"),
                  _buildTableHeaderCell("Operative Button"),
                  _buildTableHeaderCell("Status"),
                  _buildTableHeaderCell("Point Type"),
                  _buildTableHeaderCell("Actions"),
                ],
              ),
              // Table Rows
              ..._getPaginatedChargers().asMap().entries.map((entry) {
                final index = entry.key;
                final charger = entry.value;
                return TableRow(
                  // decoration: BoxDecoration(
                  //   color: index % 2 == 0 ? oGrey.withOpacity(0.2) : Colors.transparent,
                  // ),
                  children: [
                    _buildTableCell('${index + 1 + (_currentPage - 1) * _rowsPerPage}'),
                    _buildTableCell(charger.stationId ?? ""),
                    _buildTableCell(charger.organizationName ?? ""),
                    _buildTableStatusCell(index),
                    _buildTableCell(charger.status ?? ""),
                    _buildTableCell(charger.pointType ?? ""),
                    _buildTableActionsCell(index, charger),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: oBlack,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: oBlack,
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTableStatusCell(int index) {
    return Center(
      child: Switch(
        value: _filteredChargers[index].isOperative, // Access charger via index
        onChanged: (_) => onToggle(index), // Pass the correct index to `onToggle`
        activeColor: oGreen,
        inactiveThumbColor: oGrey,
      ),
    );
  }


  Widget _buildTableActionsCell(int index, Charger charger) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: SvgPicture.asset('icons/edit.svg', color: oBlue, width: 20, height: 20.0,),
          onPressed: () => _editCharger(context, charger),
        ),
        IconButton(
          icon: SvgPicture.asset('icons/delete.svg', color: oRed, width: 20, height: 20.0,),
          onPressed: () => _deleteCharger(charger),
        ),
      ],
    );
  }
}