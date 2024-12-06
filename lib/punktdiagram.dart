import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:raman/navigationbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'fetch_data.dart' as data;

class Punktdiagram extends StatefulWidget {
  Punktdiagram({super.key});

  @override
  State<Punktdiagram> createState() => _PunktdiagramState();
}

class _PunktdiagramState extends State<Punktdiagram> {
  //the following variables is to have a data string for the loaded data
  Map<String, dynamic> smerteData = {};
  Map<String, dynamic> sleepData = {};
  Map<String, dynamic> socialData = {};
  Map<String, dynamic> moodData = {};
  Map<String, dynamic> aktivitetsData = {};
  //the following variables is to define the length of data to aquire from the dB
  int datasize = 7;
  int fetchedDatasize = 31;
  //bool for defining whether the dat for the program has been loaded
  bool isLoading = true;
  List<String> lengthOfDataStatus = [
    //this List is to define the options available for the user
    "Uge",
    "Måned",
    //"År",
  ];

  String? chosenDataLength =
      "Uge"; //This String? is to define what option is selected by the user, "Uge" is the predefined option
  Map<String, bool> showParametreStatus = {
    //This Map is to define which parametre should be displayed
    "Smerte": true,
    "Søvn": false,
    "Social": false,
    "Humør": false,
    "Aktivitet": false,
  };
  @override
  void initState() {
    //the functions that is needed to run at the start of the file
    super.initState();
    _fetchData();
  }

  void updateParametre(Map<String, bool> parametre) {
    setState(() {
      showParametreStatus = parametre;
    });
  }

  void updateLength(String Length) {
    setState(() {
      chosenDataLength = Length;
      if (chosenDataLength == "Uge") {
        datasize = 7;
      } else if (chosenDataLength == "Måned") {
        datasize = 31;
      }
    });
  }

  Future<void> _fetchData() async {
    smerteData = data.smerteData;
    sleepData = data.sleepData;
    socialData = data.socialData;
    moodData = data.moodData;
    aktivitetsData = data.aktivitetsData;
    isLoading = false;
  }

  Widget build(BuildContext context) {
    if (isLoading) {
      //loading page, that is active until data is loaded
      //TODO: add descriptive text of why the program is loading
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 228),
        appBar: Topappbar(pagename: "Punktdiagram"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      //the rendering of the page
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),

      appBar: Topappbar(pagename: "Punktdiagram"),
      bottomNavigationBar: const Bottomappbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OptionsMenu(
                  items: showParametreStatus,
                  updatedItems: updateParametre,
                ),
              ),
              Expanded(
                child: OptionsMenuSingle(
                  items: lengthOfDataStatus,
                  updatedItem: updateLength,
                  selectedItem: chosenDataLength,
                ),
              )
            ],
          ),
          const Divider(
            height: 10,
          ),
          Expanded(
            //the graph
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 6),
              child: LineChartSample(
                  smerteData: smerteData,
                  sleepData: sleepData,
                  socialData: socialData,
                  moodData: moodData,
                  aktivitetsData: aktivitetsData,
                  showParametreStatus: showParametreStatus,
                  datasize: datasize),
            ),
          ),
        ],
      ),
    );
  }
}

class OptionsMenu extends StatefulWidget {
  final Map<String, bool> items;
  final Function(Map<String, bool>) updatedItems;

  OptionsMenu({
    Key? key,
    required this.items,
    required this.updatedItems,
  }) : super(key: key);

  @override
  State<OptionsMenu> createState() => _OptionsMenuState();
}

class _OptionsMenuState extends State<OptionsMenu> {
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      widget.items[itemValue] = isSelected;
    });
    widget.updatedItems(widget.items);
  }

  Color _getColor(String item) {
    switch (item) {
      case "Smerte":
        return Colors.blue;
      case "Søvn":
        return Colors.red;
      case "Social":
        return Colors.purple;
      case "Humør":
        return Colors.green;
      case "Aktivitet":
        return Colors.amber;
      default:
        return Colors.pink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vælg parametre',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: widget.items.keys.map((item) {
              return CheckboxListTile(
                value: widget.items[item],
                title: Text(
                  item,
                  style: const TextStyle(fontSize: 13),
                ),
                activeColor: _getColor(item),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (isChecked) {
                  _itemChange(item, isChecked!);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class OptionsMenuSingle extends StatefulWidget {
  final List<String> items;
  final Function(String) updatedItem;
  String? selectedItem;

  OptionsMenuSingle({
    Key? key,
    required this.items,
    required this.updatedItem,
    required this.selectedItem,
  }) : super(key: key);

  @override
  State<OptionsMenuSingle> createState() => _OptionsMenuSingleState();
}

class _OptionsMenuSingleState extends State<OptionsMenuSingle> {
  void _itemChange(String itemValue) {
    setState(() {
      widget.selectedItem = itemValue;
    });
    widget.updatedItem(itemValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vælg tidsramme',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: widget.items.map((item) {
              return RadioListTile<String>(
                value: item,
                groupValue: widget.selectedItem,
                title: Text(item),
                onChanged: (value) {
                  if (value != null) {
                    _itemChange(value);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class DropDownMenuWithSingleTrue extends StatefulWidget {
  final List<String> items;
  final Function(String) updatedItem;
  String? selectedItem;

  DropDownMenuWithSingleTrue(
      {super.key,
      required this.items,
      required this.updatedItem,
      required this.selectedItem});

  @override
  State<DropDownMenuWithSingleTrue> createState() =>
      _DropDownMenuWithSingleTrueState();
}

class _DropDownMenuWithSingleTrueState
    extends State<DropDownMenuWithSingleTrue> {
  bool _isDropdownOpen = false;

  void _itemChange(String itemValue) {
    setState(() {
      widget.selectedItem = itemValue;
    });
    widget.updatedItem(itemValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isDropdownOpen = !_isDropdownOpen;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    /*widget.selectedItem == null
                        ?*/
                    'vælg tidsramme' /*: widget.selectedItem!*/,
                  ),
                  Icon(
                    _isDropdownOpen
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
          ),
          if (_isDropdownOpen)
            Column(
              children: widget.items.map((item) {
                return RadioListTile<String>(
                  value: item,
                  groupValue: widget.selectedItem,
                  title: Text(item),
                  onChanged: (value) {
                    if (value != null) {
                      _itemChange(value);
                      widget.updatedItem(value);
                    }
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class LineChartSample extends StatelessWidget {
  final Map<String, dynamic> smerteData;
  final Map<String, dynamic> sleepData;
  final Map<String, dynamic> socialData;
  final Map<String, dynamic> moodData;
  final Map<String, dynamic> aktivitetsData;
  final Map<String, bool> showParametreStatus;
  final int datasize;

  LineChartSample({
    Key? key,
    required this.smerteData,
    required this.sleepData,
    required this.socialData,
    required this.moodData,
    required this.aktivitetsData,
    required this.showParametreStatus,
    required this.datasize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure we are only taking the last `datasize` entries
    int actualDataSize =
        smerteData.length < datasize ? smerteData.length : datasize;

    double? interval;
    if (datasize == 7) {
      interval = 1;
    } else {
      interval = null;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: actualDataSize.toDouble() - 1,
          minY: 0,
          maxY: 10,
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Colors.black, width: 2),
              left: BorderSide(color: Colors.black, width: 2),
              top: BorderSide(color: Colors.grey, width: 1),
              right: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            verticalInterval: 1,
            horizontalInterval: 1,
            getDrawingVerticalLine: (value) {
              if (value.toInt() >= 0 && value.toInt() < actualDataSize) {
                return const FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                );
              } else {
                return FlLine(
                  color: Colors.transparent,
                );
              }
            },
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Colors.grey,
                strokeWidth: 1,
              );
            },
          ),
          lineBarsData: _createLineBarsData(actualDataSize),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 40, // Allow extra room for rotated labels
                showTitles: true,
                interval: interval,
                getTitlesWidget: (value, meta) {
                  // Reverse the keys to align with right-to-left order
                  int reversedIndex = actualDataSize - 1 - value.toInt();
                  if (reversedIndex >= 0 && reversedIndex < actualDataSize) {
                    String rawDate = smerteData.keys
                        .toList()
                        .reversed
                        .elementAt(reversedIndex);

                    // Parse and format the date as dd/MM
                    List<String> parts = rawDate.split('-');
                    int day = int.parse(parts[0]);
                    int month = int.parse(parts[1]);
                    String formattedDate = '$day/$month';

                    // Rotate the text 90 degrees
                    return Transform.rotate(
                      angle: -pi / 2, // Rotate 90 degrees counterclockwise
                      child: Text(
                        formattedDate,
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 30),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _createLineBarsData(int actualDataSize) {
    return [
      if (showParametreStatus["Smerte"] ?? false)
        LineChartBarData(
          spots: _createFlSpots(smerteData, actualDataSize),
          isCurved: false,
          color: Colors.blue,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),
      if (showParametreStatus["Søvn"] ?? false)
        LineChartBarData(
          spots: _createFlSpots(sleepData, actualDataSize),
          isCurved: false,
          color: Colors.red,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),
      if (showParametreStatus["Social"] ?? false)
        LineChartBarData(
          spots: _createFlSpots(socialData, actualDataSize),
          isCurved: false,
          color: Colors.purple,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),
      if (showParametreStatus["Humør"] ?? false)
        LineChartBarData(
          spots: _createFlSpots(moodData, actualDataSize),
          isCurved: false,
          color: Colors.green,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),
      if (showParametreStatus["Aktivitet"] ?? false)
        LineChartBarData(
          spots: _createFlSpots(aktivitetsData, actualDataSize),
          isCurved: false,
          color: Colors.amber,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),
    ];
  }

  List<FlSpot> _createFlSpots(Map<String, dynamic> data, int actualDataSize) {
    List<MapEntry<String, dynamic>> reversedEntries =
        data.entries.toList().reversed.toList();
    return reversedEntries
        .asMap()
        .entries
        .map((entry) {
          int index = entry.key;
          var value = entry.value.value;
          return value != null
              ? FlSpot((actualDataSize - 1 - index).toDouble(), value)
              : FlSpot.nullSpot;
        })
        .take(actualDataSize)
        .toList();
  }
}
