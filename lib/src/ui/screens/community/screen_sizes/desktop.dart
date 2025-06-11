import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';

import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../forms/communities/community_create_form.dart';
import '../../../../forms/communities/community_edit_form.dart';
import '../../../../models/commuinities_model.dart';
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

class CommunitiesDesktopUi extends StatefulWidget {
  const CommunitiesDesktopUi({super.key});

  @override
  State<CommunitiesDesktopUi> createState() => _CommunitiesDesktopUiState();
}

class _CommunitiesDesktopUiState extends State<CommunitiesDesktopUi> {
  Uint8List? _pdfFileBytes;

  final ScrollController _dataScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final int _rowsPerPage = 8;
  int _currentPage = 1;

  List<Communities> communities = [];
  List<Communities> _filteredCommunities = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController.addListener(_filteredCommunity);
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
        Uri.parse(BaseURLConfig.communitiesApiURL),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        LoggerUtil.getInstance.print("GET Communities:\n$responseData");

        List<Communities> fetchedCommunities = (responseData as List)
            .map<Communities>((json) => Communities.fromJson(json))
            .toList();

        setState(() {
          communities = fetchedCommunities;
          _filteredCommunities = fetchedCommunities;
        });
      } else {
        throw Exception('Failed to load Communities');
      }
    } catch (e) {
      LoggerUtil.getInstance.print("Error fetching data: \n$e");
    }
  }


  Future<void> createCommunity(
      String communityName,
      String communityCode,
      int communityTotalChargers,
      Uint8List? communityLicenseBytes, // Change to Uint8List to hold file bytes
      BuildContext context,
      ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(BaseURLConfig.communitiesApiURL),
      );

      // Add fields to the request
      request.fields['organization_name'] = communityName;
      request.fields['organization_code'] = communityCode;
      request.fields['total_chargers'] = communityTotalChargers.toString();

      // Add the PDF file if it exists
      if (communityLicenseBytes != null) {
        // Assuming you want to send it as 'license'
        request.files.add(
          http.MultipartFile.fromBytes(
            'license',
            communityLicenseBytes,
            filename: 'community_license.pdf',
          ),
        );
      }

      // Set headers
      request.headers['Authorization'] = 'Bearer $token';

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        final json = await response.stream.bytesToString();
        LoggerUtil.getInstance.print("json CREATE USERS:\n$json");

        Navigator.pop(context); // Close the dialog here
        showCreateAlertDialog(
          context,
          'Community Creation!',
          'Successfully created the community',
          true,
        );
        fetchData();
      } else {
        final json = await response.stream.bytesToString();
        Map<String, dynamic> map = jsonDecode(json);
        LoggerUtil.getInstance.print("Server Response Data>>>${map['data']}");
        showErrorAlertDialog(context, 'Community Creation!', map['data'], false);
      }
    } catch (e) {
      LoggerUtil.getInstance.print("Error creating community: \n$e");
    }
  }


  Future<void> editCommunity(
      int communityId,
      String communityName,
      String communityCode,
      int communityTotalChargers,
      Uint8List? communityLicenseBytes,
      BuildContext context,
      ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Create a multipart request
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${BaseURLConfig.communitiesApiURL}/$communityId'), // Append communityId for specific update
      );

      // Add fields to the request
      request.fields['organization_name'] = communityName;
      request.fields['organization_code'] = communityCode;
      request.fields['total_chargers'] = communityTotalChargers.toString();

      // Add the PDF file if it exists
      if (communityLicenseBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'license',
            communityLicenseBytes,
            filename: 'community_license.pdf',
          ),
        );
      }

      // Set headers
      request.headers['Authorization'] = 'Bearer $token';

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        final json = await response.stream.bytesToString();
        LoggerUtil.getInstance.print("json edit USERS:\n$json");

        Navigator.pop(context); // Close the dialog here
        showEditAlertDialog(
          context,
          'Community Updation!',
          'Successfully updated the community',
          true,
        );
        fetchData();
      } else {
        final json = await response.stream.bytesToString();
        Map<String, dynamic> map = jsonDecode(json);
        LoggerUtil.getInstance.print("Server Response Data>>>${map['data']}");
        showErrorAlertDialog(context, 'Community Updation!', map['data'], false);
      }
    } catch (e) {
      LoggerUtil.getInstance.print("Error editing community: \n$e");
    }
  }


  Future<void> deleteCommunity(String communityId) async {
    print("Delete community Id >>>" + communityId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.delete(
        Uri.parse('${BaseURLConfig.communitiesApiURL}/$communityId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Delete community>>>ResponseBody>>>>" + response.body);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final json = response.body;
          Map<String, dynamic> map = jsonDecode(json);
          //print("Server Response Data>>>${map['data']}");
          showDeleteAlertDialog(
              context, 'Community Deletion!', 'Successfully deleted the community', true);
          fetchData();
        } else {
          print("Empty response body");
        }
      } else {
        final json = response.body;
        Map<String, dynamic> map = jsonDecode(json);
        print("Server Response Data>>>${map['data']}");
        showErrorAlertDialog(context, 'Community Deletion!', map['data'], false);
      }
    } catch (e) {
      print("Error during HTTP request: $e");
    }
  }

  void _filteredCommunity() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCommunities = communities.where((community) {
        return community.totalChargers.toString().toLowerCase().contains(query) ||
            community.organizationName!.toLowerCase().contains(query) ||
            community.organizationCode!.toLowerCase().contains(query) ;
      }).toList();
    });
  }

  List<Communities> _getPaginatedCommunities() {
    int startIndex = (_currentPage - 1) * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    endIndex = endIndex > _filteredCommunities.length ? _filteredCommunities.length : endIndex;
    return _filteredCommunities.sublist(startIndex, endIndex);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> decodeAndHandlePdf(String base64Str, String fileName) async {
    try {
      // Decode the Base64 string into bytes
      Uint8List decodedBytes = base64.decode(base64Str);

      if (kIsWeb) {
        // For Web: Create a Blob and trigger a download
        final blob = html.Blob([decodedBytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);

        // Create an anchor element and trigger a download
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", fileName) // Set the download file name
          ..click();

        // Cleanup
        html.Url.revokeObjectUrl(url);
      } else {
        // For Mobile or Desktop: Save the PDF to a file and allow opening
        Directory tempDir = await getTemporaryDirectory();
        String filePath = '${tempDir.path}/$fileName';

        // Write the decoded bytes to a file
        File file = File(filePath);
        await file.writeAsBytes(decodedBytes);

        print("PDF file saved at $filePath");

        // Optionally: Open the file using a package like open_filex (for mobile)
        // await OpenFilex.open(filePath);
      }
    } catch (e) {
      print("Error handling PDF file: $e");
    }
  }

  List<DataRow> getCurrentPageRows() {
    List<Communities> currentPageUsers = _getPaginatedCommunities();
    return currentPageUsers.asMap().entries.map((entry) {
      final index = entry.key;
      final community = entry.value;
      return DataRow(cells: [
        DataCell(Text('${index + 1 + (_currentPage - 1) * _rowsPerPage}', style: DataCellTextStyle)),
        DataCell(Text(community.organizationName!, style: DataCellTextStyle)),
        DataCell(Text(community.organizationCode!, style: DataCellTextStyle)),
        DataCell(Text(community.totalChargers.toString(), style: DataCellTextStyle)),

        DataCell(InkWell(
          onTap: () async {
            // Decode and handle the PDF file, passing the file name you want
            await decodeAndHandlePdf(community.license!, '${community.organizationName} license agreement.pdf');
          },
          child: Text('${community.organizationName} License', style: DataCellTextStyle.copyWith(color: oBlue)),
        )),
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
                    _editCommunity(context, community);
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
                    _deleteCommunity(community);
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

  void _createCommunity(BuildContext context) async {
    final create_community = Communities(
      organizationName: '',
      organizationCode: '',
      totalChargers: 0,
    );
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController create_communityNameController =
    TextEditingController();
    final TextEditingController create_communityCodeController =
    TextEditingController();
    final TextEditingController create_communityTotalChargersController = TextEditingController();

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
                        Text("Community Creation",
                          style: GoogleFonts.poppins(
                              color: oBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        // const SizedBox(height: 10,),
                        CreateCommunityFormScreen(
                          formKey: _formKey,
                          communityNameController: create_communityNameController,
                          communityCodeController: create_communityCodeController,
                          communityTotalChargersController: create_communityTotalChargersController,
                          communities: create_community,
                          onFileSelected: (Uint8List? bytes) {
                            setState(() {
                              _pdfFileBytes = bytes; // Update the state variable
                            });
                          },
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
                                    create_community.organizationName = create_communityNameController.text;
                                    create_community.organizationCode = create_communityCodeController.text;
                                    create_community.totalChargers = int.parse(create_communityTotalChargersController.text);

                                    await createCommunity(
                                      create_community.organizationName!,
                                      create_community.organizationCode!,
                                      create_community.totalChargers!,
                                      _pdfFileBytes,
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

  void _editCommunity(BuildContext context, Communities communities) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController edit_communityNameController =
    TextEditingController();
    final TextEditingController edit_communityCodeController =
    TextEditingController();
    final TextEditingController edit_communityTotalChargersController = TextEditingController();

    Uint8List? existingPdfBytes;

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
                        "Community Updation",
                        style: GoogleFonts.poppins(
                          color: oBlack,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      EditCommunityFormScreen(
                        formKey: _formKey,
                        communityNameController: edit_communityNameController,
                        communityCodeController: edit_communityCodeController,
                        communityTotalChargersController: edit_communityTotalChargersController,
                        communities: communities,
                        onFileSelected: (Uint8List? bytes) {
                          setState(() {
                            existingPdfBytes = bytes; // Update the local bytes
                          });
                        },

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
                                  if (communities.organizationId != null) {
                                    editCommunity(
                                      communities.organizationId!,
                                      edit_communityNameController.text,
                                      edit_communityCodeController.text,
                                      int.parse(edit_communityTotalChargersController.text),
                                      existingPdfBytes,
                                      context,
                                    );
                                  } else {
                                    // Handle the case where user.userId is null
                                    print('Community ID is null');
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

  void _deleteCommunity(Communities communities) async {
    final response = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: oWhite,
          title: Text(
            'Delete Community',
            style: GoogleFonts.poppins(
              color: oBlack,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete ${communities.organizationName}?',
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
      await deleteCommunity(communities.organizationId.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: oWhite,
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
                              " / Communities",
                              style: GoogleFonts.poppins(
                                color: oBlack,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        //const Spacer(),
                        Row(
                          children: [
                            Container(
                              width: 300,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 0.5, color: oBlack),
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
                                    prefixIcon: Icon(
                                      CupertinoIcons.search,
                                      color: oBlack.withOpacity(0.7),
                                      size: 18,
                                    ),
                                  ),
                                  style: GoogleFonts.poppins(
                                    color: oBlack,
                                    fontSize: 13,
                                  ),
                                  cursorColor: oBlack,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                LoggerUtil.getInstance.print("Add community button pressed");
                                _createCommunity(context);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(oBlack),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                fixedSize:
                                MaterialStateProperty.all(const Size(160, 40)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.add,
                                    size: 18,
                                    color: oWhite,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Add Community",
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
                    const SizedBox(height: 20),
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
                  totalItems: _filteredCommunities.length,
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
        0: FixedColumnWidth(50), // S.No column
        1: FlexColumnWidth(),    // Community Name column
        2: FlexColumnWidth(),    // Community Code column
        3: FlexColumnWidth(),    // Permitted Chargers column
        4: FlexColumnWidth(),    // License Agreement column
        5: FixedColumnWidth(100), // Actions column
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Table Header
        TableRow(
          //decoration: BoxDecoration(color: oBlack),
          children: [
            _buildTableCell('S.No', isHeader: true),
            _buildTableCell('Community Name', isHeader: true),
            _buildTableCell('Community Code', isHeader: true),
            _buildTableCell('Permitted Chargers', isHeader: true),
            _buildTableCell('License Agreement', isHeader: true),
            _buildTableCell('Actions', isHeader: true),
          ],
        ),
        // Table Rows
        ..._getPaginatedCommunities().asMap().entries.map((entry) {
          final index = entry.key;
          final community = entry.value;
          return TableRow(
            // decoration: BoxDecoration(
            //   color: index.isEven ? Colors.white : Colors.grey[100],
            // ),
            children: [
              _buildTableCell('${index + 1 + (_currentPage - 1) * _rowsPerPage}'),
              _buildTableCell(community.organizationName!),
              _buildTableCell(community.organizationCode!),
              _buildTableCell('${community.totalChargers}'),
              _buildTableCell(
                '${community.organizationName} License',
                onTap: () async {
                  await decodeAndHandlePdf(
                    community.license!,
                    '${community.organizationName} license agreement.pdf',
                  );
                },
                isLink: true,
              ),
              _buildActionCell(context, community),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false, bool isLink = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isLink
          ? GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: oBlue,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
        ),
      )
          : Text(
        text,
        style: GoogleFonts.poppins(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
            color: oBlack
        ),
      ),
    );
  }

  Widget _buildActionCell(BuildContext context, Communities community) {
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
          onPressed: () => _editCommunity(context, community),
        ),
        IconButton(
          icon: SvgPicture.asset(
            'icons/delete.svg',
            color: oRed,
            width: 20.0,
            height: 20.0,
          ),
          onPressed: () => _deleteCommunity(community),
        ),
      ],
    );
  }

}
