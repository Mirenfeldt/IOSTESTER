import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'navigationbars.dart';
import 'fetch_data.dart' as data;

class RadarChartExample extends StatefulWidget {
  @override
  _RadarChartExampleState createState() => _RadarChartExampleState();
}

class _RadarChartExampleState extends State<RadarChartExample> {
  bool isDaySelected = true;
  bool isWeekSelected = true;
  bool isMonthSelected = false;

  // data.dart
  List<double> dayData = [
    data.painValue,
    data.sleepValue,
    data.activityValue,
    data.moodValue,
    data.socialValue
  ];
  List<double> weekData = [
    data.smerteUge,
    data.sovnUge,
    data.aktivitetUge,
    data.humorUge,
    data.socialUge
  ];
  List<double> monthData = [
    data.smerteManed,
    data.sovnManed,
    data.aktivitetManed,
    data.humorManed,
    data.socialManed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(pagename: "Radardiagram"),
      bottomNavigationBar: const Bottomappbar(),
      body: Column(
        children: [
          SizedBox(height: 100), // Adjust the height as needed
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCheckbox('Dag', Colors.blue, isDaySelected, (bool? value) {
                setState(() {
                  isDaySelected = value!;
                });
              }),
              _buildCheckbox('Uge', Colors.green, isWeekSelected,
                  (bool? value) {
                setState(() {
                  isWeekSelected = value!;
                });
              }),
              _buildCheckbox('Måned', Colors.red, isMonthSelected,
                  (bool? value) {
                setState(() {
                  isMonthSelected = value!;
                });
              }),
            ],
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 280, // Adjust the height as needed
                child: RadarChart(
                  RadarChartData(
                    radarTouchData: RadarTouchData(enabled: true),
                    dataSets: _getSelectedDataSets(),
                    radarBackgroundColor: Colors.transparent,
                    borderData: FlBorderData(show: true),
                    radarBorderData: BorderSide(color: Colors.black, width: 1),
                    titlePositionPercentageOffset: 0.2,
                    titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    getTitle: (index, angle) {
                      switch (index) {
                        case 0:
                          return RadarChartTitle(text: 'Smerte');
                        case 1:
                          return RadarChartTitle(text: 'Søvn');
                        case 2:
                          return RadarChartTitle(text: 'Aktivitet');
                        case 3:
                          return RadarChartTitle(text: 'Humør');
                        case 4:
                          return RadarChartTitle(text: 'Social');
                        default:
                          return RadarChartTitle(text: '');
                      }
                    },
                    tickCount: 10, // Set the number of ticks
                    ticksTextStyle:
                        TextStyle(color: Colors.transparent, fontSize: 10),
                    tickBorderData: BorderSide(color: Colors.black),
                    gridBorderData: BorderSide(color: Colors.black, width: 1),
                    radarShape: RadarShape.polygon,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(
      String period, Color color, bool isSelected, Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(
          value: isSelected,
          onChanged: onChanged,
          activeColor: color,
        ),
        Text(
          period,
          style: TextStyle(
            fontSize: 28, // Increase the text size
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
      ],
    );
  }

  List<RadarDataSet> _getSelectedDataSets() {
    List<RadarDataSet> dataSets = [];

    // Add the transparent dataset with values 0 and 10
    dataSets.add(RadarDataSet(
      fillColor: Colors.transparent,
      borderColor: Colors.transparent,
      dataEntries: [
        RadarEntry(value: 0),
        RadarEntry(value: 10),
        RadarEntry(value: 10),
        RadarEntry(value: 10),
        RadarEntry(value: 10),
      ],
    ));

    if (isDaySelected) {
      dataSets.add(RadarDataSet(
        fillColor: Colors.blue.withOpacity(0.6),
        borderColor: Colors.blue,
        entryRadius: 2,
        dataEntries:
            dayData.map((e) => RadarEntry(value: e.isNaN ? 0 : e)).toList(),
        borderWidth: 3,
      ));
    }
    if (isWeekSelected) {
      dataSets.add(RadarDataSet(
        fillColor: Colors.green.withOpacity(0.4),
        borderColor: Colors.green,
        entryRadius: 2,
        dataEntries:
            weekData.map((e) => RadarEntry(value: e.isNaN ? 0 : e)).toList(),
        borderWidth: 3,
      ));
    }
    if (isMonthSelected) {
      dataSets.add(RadarDataSet(
        fillColor: Colors.red.withOpacity(0.2),
        borderColor: Colors.red,
        entryRadius: 2,
        dataEntries:
            monthData.map((e) => RadarEntry(value: e.isNaN ? 0 : e)).toList(),
        borderWidth: 3,
      ));
    }
    if (dataSets.isEmpty) {
      dataSets.add(RadarDataSet(
        fillColor: Colors.transparent,
        borderColor: Colors.transparent,
        dataEntries: List.generate(5, (index) => RadarEntry(value: 0)),
      ));
    }
    return dataSets;
  }
}
