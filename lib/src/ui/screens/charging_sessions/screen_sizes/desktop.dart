import 'dart:convert';
import 'dart:html' as html;
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/billings_model.dart';
import '../../../../models/chargers_model.dart';
import '../../../../models/commuinities_model.dart';
import '../../../../services/api.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/logger.dart';
import '../../../../utils/routes/route_names.dart';
import '../../../widgets/custom_datatable_theme.dart';
import '../../../widgets/custom_pagination.dart';
import '../../overview/widgets/appbar.dart';
import '../../overview/widgets/side_bar.dart';


class BookingsDesktopUi extends StatefulWidget {
  const BookingsDesktopUi({super.key});

  @override
  State<BookingsDesktopUi> createState() => _BookingsDesktopUiState();
}

class _BookingsDesktopUiState extends State<BookingsDesktopUi> {

  final ScrollController _dataScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final int _rowsPerPage = 10;
  int _currentPage = 1;


  List<Billings> billings = [];
  List<Communities> communities = [];

  List<Billings> _filteredBillings = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController.addListener(_filterBillings);
  }

  Future<void> fetchData() async {
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

        setState(() {
          billings = fetchedBillings;
          _filteredBillings = fetchedBillings;
        });
      } else {
        throw Exception('Failed to load billings');
      }

      //Fetch communities
      final communityResponse = await http.get(
        Uri.parse(BaseURLConfig.communitiesApiURL),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (communityResponse.statusCode == 200) {
        final communityResponseData = json.decode(communityResponse.body);
        LoggerUtil.getInstance.print("GET communities:\n$communityResponseData");

        List<Communities> fetchedCommunities = (communityResponseData as List)
            .map<Communities>((json) => Communities.fromJson(json))
            .toList();

        setState(() {
          communities = fetchedCommunities;
        });
      } else {
        throw Exception('Failed to load communities');
      }

    } catch (e) {
      LoggerUtil.getInstance.print("Error fetching data: \n$e");
    }
  }


  void _filterBillings() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBillings = billings.where((billing) {
        return billing.startTime!.toLowerCase().contains(query) ||
            billing.transactionId.toString().contains(query) ||
            billing.userId.toString().contains(query) ||
            billing.pointId.toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  List<Billings> _getPaginatedBillings() {
    int startIndex = (_currentPage - 1) * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    endIndex =
    endIndex > _filteredBillings.length ? _filteredBillings.length : endIndex;
    return _filteredBillings.sublist(startIndex, endIndex);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  List<DataRow> getCurrentPageRows() {
    List<Billings> currentPageBillings = _getPaginatedBillings();
    DateFormat formatter = DateFormat('dd MMM yyyy HH:mm');
    DateFormat formatterTime = DateFormat('HH:mm');

    return currentPageBillings
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final billing = entry.value;

      return DataRow(cells: [
        DataCell(Text('${index + 1 + (_currentPage - 1) * _rowsPerPage}',
            style: DataCellTextStyle)),
        DataCell(
            Text(billing.transactionId.toString(), style: DataCellTextStyle)),
        DataCell(Text(billing.userId.toString(), style: DataCellTextStyle)),
        DataCell(Text(billing.stationId.toString(), style: DataCellTextStyle)),
        DataCell(Text(
            '${formatter.format(DateTime.parse(billing.startTime.toString()))} '
                '- ${formatterTime.format(
                DateTime.parse(billing.endTime.toString()))}',
            style: DataCellTextStyle
        )),
        DataCell(Center(child: Text(
            '${billing.energyConsumed}', style: DataCellTextStyle))),
        DataCell(
            Center(child: Text('₹ ${billing.cost}', style: DataCellTextStyle))),
      ]);
    }).toList();
  }

  Future<void> exportToCSV(BuildContext context, List<Billings> billings) async {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);

    DateFormat formatter = DateFormat('dd MMM yyyy HH:mm');
    DateFormat formatterTime = DateFormat('HH:mm');

    final String fileName = 'Bookings_$formattedDate.csv';

    List<List<String>> csvData = [
      // Add headers
      ['Booking Id', 'User\'s Id', 'Station ID', 'Booking date and time', 'Booking Community', 'Booking Status'],
      // Add data
      ...billings.map((item) {
        // Find matching community for each item
        final community = communities.firstWhere(
                (comm) => comm.organizationId == item.organizationId,
            orElse: () => Communities(
                organizationName: item.organizationId.toString(), // Default to organization ID if not found
                organizationId: item.organizationId
            )
        );

        return [
          item.transactionId.toString(),
          item.userId.toString(),
          item.stationId ?? '',
          '${formatter.format(DateTime.parse(item.startTime.toString()))} - ${formatterTime.format(DateTime.parse(item.endTime.toString()))}', // DateTime formatting
          community.organizationName ?? '',
          item.status ?? '',
        ];
      }),
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    if (kIsWeb) {
      final encodedFileContents = Uri.encodeComponent(csv);
      final anchor = html.AnchorElement(href: "data:text/csv;charset=utf-8,$encodedFileContents")
        ..setAttribute("download", fileName)
        ..click();
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$fileName';
      final io.File file = io.File(path);
      await file.writeAsString(csv);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CSV exported to $path'),
          duration: const Duration(seconds: 2),
        ),
      );
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
                              " / Bookings",
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
                                LoggerUtil.getInstance.print("Export Billings button pressed");
                                exportToCSV(context, billings);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(oBlack),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                fixedSize: MaterialStateProperty.all(const Size(150, 40)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(CupertinoIcons.arrow_down_square, size: 18, color: oWhite,),
                                  const SizedBox(width: 5,),
                                  Text(
                                    "Export Bookings",
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
                  totalItems: _filteredBillings.length,
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
    DateFormat formatter = DateFormat('dd MMM yyyy');
    DateFormat formatterTime = DateFormat('HH:mm');

    return Table(
      // border: TableBorder.all(
      //     color: oBlack, width: 0.6,
      //     borderRadius: BorderRadius.circular(15)
      // ),
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
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
        5: FlexColumnWidth(),
        6: FixedColumnWidth(200),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,

      children: [
        // Table Header
        TableRow(
          //decoration: BoxDecoration(color: oBlack),
          children: [
            _buildTableCell('S.No', isHeader: true),
            _buildTableCell('Booking ID', isHeader: true),
            _buildTableCell('EV Station', isHeader: true),
            _buildTableCell('Booking Date', isHeader: true),
            _buildTableCell('Booking Time', isHeader: true),
            _buildTableCell('Booking Status', isHeader: true),
            _buildTableCell('Community', isHeader: true),
          ],
        ),

        // Table Rows
        ..._getPaginatedBillings().asMap().entries.map((entry) {
          final index = entry.key;
          final bill = entry.value;

          // Find matching community
          final community = communities.firstWhere(
                (comm) => comm.organizationId == bill.organizationId,
            orElse: () => Communities(
              organizationName: bill.organizationId.toString(),
              organizationId: bill.organizationId,
            ),
          );

          // Determine the color based on booking status
          Color statusColor;
          switch (bill.status?.toLowerCase()) {
            case 'completed':
              statusColor = oBlue;
              break;
            case 'pending':
              statusColor = oPink;
              break;
            case 'cancelled':
              statusColor = oRed;
              break;
            default:
              statusColor = oGrey; // Default color for unknown status
          }


          return TableRow(
            // decoration: BoxDecoration(
            //   color: index.isEven ? Colors.white : Colors.grey[100],
            // ),
            children: [
              _buildTableCell('${index + 1 + (_currentPage - 1) * _rowsPerPage}'),
              _buildTableCell(bill.transactionId.toString()),
              _buildTableCell(bill.stationId.toString()),
              _buildTableCell(formatter.format(DateTime.parse(bill.startTime.toString()))),
              _buildTableCell('${formatterTime.format(DateTime.parse(bill.startTime.toString()))} '
                  '- ${formatterTime.format(DateTime.parse(bill.endTime.toString()))}'),
              // Status cell with dynamic size
              TableCell(
                child: Text(
                  bill.status.toString(),
                  style: GoogleFonts.poppins(
                    color: statusColor,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              _buildTableCell(community.organizationName ?? ''),

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

}