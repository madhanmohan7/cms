import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/api.dart';
import '../../../../utils/colors/colors.dart';

class analaysisCardAndChart extends StatefulWidget {
  const analaysisCardAndChart({super.key});

  @override
  State<analaysisCardAndChart> createState() => _analaysisCardAndChartState();
}

class _analaysisCardAndChartState extends State<analaysisCardAndChart> {

  String selectedPeriod = "Monthly";
  int energyConsumed = 0;
  int revenue = 0;

  List<double> powerConsumptionData = [];
  List<double> revenueData = [];

  @override
  void initState() {
    super.initState();
    _fetchEnergyData(selectedPeriod);
    _fetchRevenueData(selectedPeriod);
    _updateDummyData(selectedPeriod);
  }

  void _updateDummyData(String period) {
    setState(() {
      if (period == "Weekly") {
        powerConsumptionData = [50, 60, 25, 70, 10, 125, 150];
        revenueData = [200, 250, 150, 270, 90, 320, 480];
      } else if (period == "Monthly") {
        powerConsumptionData = [380, 500, 420, 250, 600, 900, 200];
        revenueData = [1200, 2500, 1700, 950, 3000, 6000, 1000];
      } else if (period == "Yearly") {
        powerConsumptionData = [5000, 5200, 5400, 5500, 5800, 6000, 6200];
        revenueData = [18000, 19000, 20000, 21000, 22000, 23000, 24000];
      }
    });
  }
  // Fetch data from the API
  Future<void> _fetchEnergyData(String period) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(BaseURLConfig.powerConsumeApiURL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "period": period.toLowerCase()
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          energyConsumed = data['energyConsumed'];
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> _fetchRevenueData(String period) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(BaseURLConfig.revenueApiURL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "period": period.toLowerCase()
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          revenue = data['revenue'];
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            _buildCard(225, 150, oYellowAccent, energyConsumed, 'Power Consumption', 'icons/power1.svg'),
            const SizedBox(height: 20,),
            _buildCard(225, 150, oOrange, revenue, 'Revenue', 'icons/rupee.svg'),
          ],
        ),
        const SizedBox(width: 15,),
        Container(
          width: MediaQuery.of(context).size.width * 0.39,
          height: 325,
          decoration: BoxDecoration(
            color: oWhite,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: oBlack.withOpacity(0.1),
                offset: const Offset(1, 1),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: oWhite,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: oBlack.withOpacity(0.1),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(13),
                        child: SvgPicture.asset(
                          'icons/chart.svg',
                          width: 22,
                          height: 22,
                          color: oBlack,
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Text("Power\nConsumption",
                        style: GoogleFonts.epilogue(
                          color: oBlack,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          //fontStyle: FontStyle.italic
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 226,
                    height: 50,
                    decoration: BoxDecoration(
                      color: oGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.only(top:5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPeriodButton("Weekly"),
                        _buildPeriodButton("Monthly"),
                        _buildPeriodButton("Yearly"),
                      ],
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: _buildLineChart(powerConsumptionData, oBlack),
              ),

            ],
          ),
        ),
        const SizedBox(width: 15,),
        Container(
          width: MediaQuery.of(context).size.width * 0.39,
          height: 325,
          decoration: BoxDecoration(
            color: oWhite,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: oBlack.withOpacity(0.1),
                offset: const Offset(1, 1),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: oWhite,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: oBlack.withOpacity(0.1),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(13),
                        child: SvgPicture.asset(
                          'icons/chart.svg',
                          width: 22,
                          height: 22,
                          color: oBlack,
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Text("Revenue\nAnalysis Chart",
                        style: GoogleFonts.epilogue(
                          color: oBlack,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          //fontStyle: FontStyle.italic
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 226,
                    height: 50,
                    decoration: BoxDecoration(
                      color: oGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.only(top:5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPeriodButton("Weekly"),
                        _buildPeriodButton("Monthly"),
                        _buildPeriodButton("Yearly"),
                      ],
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: _buildLineChart(revenueData, oGreen),
              ),


            ],
          ),
        ),

      ],
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = selectedPeriod == period;
    return TextButton(
      onPressed: () {
        setState(() {
          selectedPeriod = period;
        });
        _fetchEnergyData(period);
        _fetchRevenueData(period);
        _updateDummyData(period);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isSelected ? oGreen : oWhite,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      child: Text(
        period,
        style: GoogleFonts.poppins(
          color: isSelected ? oWhite : oBlack,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
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

  Widget _getBottomTitle(int index) {
    final labels = selectedPeriod == "Weekly"
        ? ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        : selectedPeriod == "Monthly"
        ? List.generate(7, (i) => "${i + 1}")
        : ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"];
    if (index < 0 || index >= labels.length) return const SizedBox.shrink();
    return Text(
      labels[index],
      style: GoogleFonts.poppins(fontSize: 10, color: oBlack),
    );
  }
  Widget _buildLineChart(List<double> data, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) => _getBottomTitle(value.toInt()),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, _) => Text(
                  value.toStringAsFixed(0),
                  style: GoogleFonts.poppins(fontSize: 10, color: oBlack),
                ),
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value);
              }).toList(),
              isCurved: true,
              color: color,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: color.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
