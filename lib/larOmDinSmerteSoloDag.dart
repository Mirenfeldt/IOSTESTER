import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'navigationbars.dart';
import 'fetch_data.dart' as data;
import 'laromdinsmerteMellemPage.dart' as laromdinsmerteMellemPage;

class LarOmDinSmerteSoloDagPage1 extends StatefulWidget {
  int chosenDateIndex;
  bool goodDay;
  bool badDay;
  String chosenDate;
  LarOmDinSmerteSoloDagPage1(
      {super.key,
      required this.chosenDateIndex,
      required this.goodDay,
      required this.badDay,
      required this.chosenDate});

  @override
  State<LarOmDinSmerteSoloDagPage1> createState() =>
      _LarOmDinSmerteSoloDagPage1State();
}

class _LarOmDinSmerteSoloDagPage1State
    extends State<LarOmDinSmerteSoloDagPage1> {
  List<Map<String, Map<String, bool>>> aktiviteterForAlleIndlesteGodeDage = [];
  List<Map<String, Map<String, bool>>> aktiviteterForAlleIndlesteDarligeDage =
      [];

  List<String> top10aktiviteter = [];
  final PageController _pageController = PageController();

  final List<Color> cardColors = [
    Color(0xFFDC143C), // Crimson
    Color(0xFF32CD32), // Lime Green
    Color(0xFF4169E1), // Royal Blue
    Color(0xFFFFD700), // Gold
    Color(0xFFFF00FF), // Magenta
    Color(0xFF40E0D0), // Turquoise
    Color(0xFFFF7F50), // Coral
    Color(0xFF4B0082), // Indigo
    Color(0xFF7FFF00), // Chartreuse
    Color(0xFF708090), // Slate Gray
  ];
  Map<String, Map<String, bool>> aktiviteterForDagen = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
    processData();
  }

  _fetchData() {
    aktiviteterForAlleIndlesteGodeDage = data.dataGodeDageForUseInApp;
    aktiviteterForAlleIndlesteDarligeDage = data.dataBadDaysForUseInApp;
    if (widget.chosenDateIndex != 5) {
      if (widget.goodDay) {
        aktiviteterForDagen =
            data.dataGodeDageForUseInApp[widget.chosenDateIndex];
      } else if (widget.badDay) {
        aktiviteterForDagen =
            data.dataBadDaysForUseInApp[widget.chosenDateIndex];
      }
    }
  }

  _titleBoxColor() {
    Color titleBoxColor = const Color.fromARGB(255, 243, 243, 228);
    if (widget.goodDay) {
      titleBoxColor = const Color.fromARGB(199, 33, 196, 18);
    } else if (widget.badDay) {
      titleBoxColor = const Color.fromARGB(200, 200, 20, 20);
    }
    return titleBoxColor;
  }

  _titleTextColor() {
    Color titleColor = const Color.fromARGB(255, 0, 0, 0);
    if (widget.goodDay || widget.badDay) {
      titleColor = const Color.fromARGB(255, 255, 255, 255);
    }
    return titleColor;
  }

  void processData() {
    Map<String, int> trueCountMap = {};

    for (var map in aktiviteterForAlleIndlesteGodeDage) {
      map.forEach((key, value) {
        value.forEach((innerKey, innerValue) {
          if (innerValue) {
            trueCountMap[innerKey] = (trueCountMap[innerKey] ?? 0) + 1;
          }
        });
      });
    }

    var sortedEntries = trueCountMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    top10aktiviteter = sortedEntries.take(10).map((e) => e.key).toList();
    setState(() {});
  }

  Color _vASColor(double value) {
    double ratio = value / 10;
    if (ratio <= 0.5) {
      // Transition from red to yellow
      return Color.lerp(Colors.red, Colors.yellow, ratio * 2)!;
    } else {
      // Transition from yellow to green
      return Color.lerp(Colors.yellow, Colors.green, (ratio - 0.5) * 2)!;
    }
  }

  Color _vASColorInverted(double value) {
    double ratio = value / 10;
    if (ratio <= 0.5) {
      // Transition from red to yellow
      return Color.lerp(Colors.green, Colors.yellow, ratio * 2)!;
    } else {
      // Transition from yellow to green
      return Color.lerp(Colors.yellow, Colors.red, (ratio - 0.5) * 2)!;
    }
  }

  _textFieldContent() {
    String fieldContent = "";
    double painDivergencePercentage;

    if (widget.goodDay) {
      if (widget.chosenDateIndex == 5) {
        double gnsSmerte = 0;
        int k = 0;
        for (var i = 0; i < data.godeDageVas.length; i++) {
          gnsSmerte = data.godeDageVas[i]["Smerte"]!;
          k++;
        }
        if (k != 0) {
          gnsSmerte = gnsSmerte / k;
        }
        painDivergencePercentage =
            (((gnsSmerte - data.smerteManed) / data.smerteManed) * 100).abs();
        fieldContent =
            "Igennem de angivede dage kan det ses, at den gennemsnitlige smerte har været ${_vasValues("Smerte")!.toStringAsFixed(1)}. Det afviger med ${painDivergencePercentage.toStringAsFixed(1)}% fra det nuværende månedelige gennemsnit for smerte. Du kan se mere om hvilke aktiviteter, der kan have været årsagen til dette på den forrige side.";
      } else {
        painDivergencePercentage = ((data.godeDageVas[widget.chosenDateIndex]
                        ["Smerte"]! -
                    data.godeDageVas[widget.chosenDateIndex]
                        ["Gennemsnitsmerte"]!) /
                data.godeDageVas[widget.chosenDateIndex]["Gennemsnitsmerte"]! *
                100)
            .abs();
        fieldContent =
            "Denne dag har været en god dag, da din smerte har været på ${data.godeDageVas[widget.chosenDateIndex]["Smerte"]!.toStringAsFixed(1)}. Dette er væsentligt bedre, end hvad du ellers indrapporterer. Det er faktisk hele ${painDivergencePercentage.toStringAsFixed(1)}% lavere. Du kan se mere om hvilke aktiviteter, der kan have været årsagen til dette på den forrige side.";
      }
    }
    if (widget.badDay) {
      if (widget.chosenDateIndex == 5) {
        double gnsSmerte = 0;
        int k = 0;
        for (var i = 0; i < data.godeDageVas.length; i++) {
          gnsSmerte = data.badDaysVas[i]["Smerte"]!;
          k++;
        }
        if (k != 0) {
          gnsSmerte = gnsSmerte / k;
        }
        painDivergencePercentage =
            (((gnsSmerte - data.smerteManed) / data.smerteManed) * 100).abs();
        fieldContent =
            "Igennem de angivede dage kan det ses, at den gennemsnitlige smerte har været ${_vasValues("Smerte")!.toStringAsFixed(1)}. Det afviger med ${painDivergencePercentage.toStringAsFixed(1)}% fra det nuværende månedlige gennemsnit for smerte. Du kan se mere om hvilke aktiviteter du foretager dig på dagen og på dagene ledende op til disse dårlige dage på den forrige side";
      } else {
        painDivergencePercentage = ((data.badDaysVas[widget.chosenDateIndex]
                        ["Smerte"]! -
                    data.badDaysVas[widget.chosenDateIndex]
                        ["Gennemsnitsmerte"]!) /
                data.badDaysVas[widget.chosenDateIndex]["Gennemsnitsmerte"]! *
                100)
            .abs();
        fieldContent =
            "Denne dag har været en dårlig dag. Dette kan ses, da du har haft mere ondt end ellers. Du har indrapporteret din smerte til at være på ${data.badDaysVas[widget.chosenDateIndex]["Smerte"]!.toStringAsFixed(1)}. Dette afviger sig med ${painDivergencePercentage.toStringAsFixed(1)}% fra den nuværende måneds gennemsnit.";
      }
    }
    return fieldContent;
  }

  _vasValues(String searchedForString) {
    double calculateAverage(List<Map<String, double>> data, String key) {
      double sum = 0;
      int count = 0;

      for (var entry in data) {
        if (entry.containsKey(key)) {
          sum += entry[key]!;
          count++;
        }
      }

      return count > 0 ? sum / count : 0;
    }

    double? vASscoreToReturn = 0;
    if (widget.chosenDateIndex != 5) {
      if (widget.goodDay) {
        vASscoreToReturn =
            data.godeDageVas[widget.chosenDateIndex][searchedForString];
      }
      if (widget.badDay) {
        vASscoreToReturn =
            data.badDaysVas[widget.chosenDateIndex][searchedForString];
      }
    } else {
      if (widget.goodDay) {
        vASscoreToReturn =
            calculateAverage(data.godeDageVas, searchedForString);
      }
      if (widget.badDay) {
        vASscoreToReturn = calculateAverage(data.badDaysVas, searchedForString);
      }
    }

    return vASscoreToReturn;
  }

  double textSizePage2 = 18;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(
        pagename: widget.chosenDate,
        titleBoxColor: _titleBoxColor(),
        titleTextColor: _titleTextColor(),
      ),
      bottomNavigationBar: const Bottomappbar(),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: <Widget>[
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 1),
                        (widget.chosenDateIndex != 5)
                            ? CustomBarChartSoloDag(
                                aktiviteterForDagen: aktiviteterForDagen,
                                cardColors: cardColors,
                                top10aktiviteter: top10aktiviteter,
                                maxYValue:
                                    (widget.chosenDateIndex == 5) ? 40 : 10,
                              )
                            : CustomBarChartSamlet(
                                cardColors: cardColors,
                                top10aktiviteter: top10aktiviteter,
                                maxYValue:
                                    (widget.chosenDateIndex == 5) ? 35 : 10,
                                listOfaktiviteterForDagen: (widget.goodDay)
                                    ? data.dataGodeDageForUseInApp
                                    : data.dataBadDaysForUseInApp,
                              )
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Smerte: ${_vasValues("Smerte")!.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: textSizePage2 + 4,
                              fontWeight: FontWeight.bold,
                              //color: _vASColorInverted(_vasValues("Smerte"))
                            ),
                          ),
                          Text(
                            "Gennemsnitsmerte: ${_vasValues("Gennemsnitsmerte")!.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: textSizePage2 - 4,
                              // color: _vASColorInverted(
                              //         _vasValues("Gennemsnitsmerte"))
                              //     .withOpacity(1),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: _titleBoxColor(), width: 4),
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Social aktivitet: ${_vasValues("Social")!.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: textSizePage2,
                                    //color: _vASColor(_vasValues("Social"))
                                  ),
                                ),
                                Text(
                                  "Søvn: ${_vasValues("Søvn")!.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: textSizePage2,
                                    //color: _vASColor(_vasValues("Søvn"))
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Fysisk aktivitet: ${_vasValues("Aktivitetsniveau")!.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: textSizePage2,
                                    //color: _vASColor(
                                    //    _vasValues("Aktivitetsniveau"))
                                  ),
                                ),
                                Text(
                                  "Humør: ${_vasValues("Humør")!.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: textSizePage2,
                                    // color: _vASColor(_vasValues("Humør"))
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: _titleBoxColor(), width: 4),
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _textFieldContent(),
                          style: TextStyle(fontSize: textSizePage2),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 2,
              effect: const WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LegendWidget extends StatelessWidget {
  const LegendWidget({
    super.key,
    required this.name,
    required this.color,
  });
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xff757391),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class LegendsListWidget extends StatelessWidget {
  const LegendsListWidget({
    super.key,
    required this.legends,
  });
  final List<Legend> legends;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: legends
          .map(
            (e) => LegendWidget(
              name: e.name,
              color: e.color,
            ),
          )
          .toList(),
    );
  }
}

class Legend {
  Legend(this.name, this.color);
  final String name;
  final Color color;
}

class CustomBarChartSoloDag extends StatelessWidget {
  Map<String, Map<String, bool>> aktiviteterForDagen;
  List<String> top10aktiviteter;
  List<Color> cardColors;
  double maxYValue;

  CustomBarChartSoloDag({
    super.key,
    required this.aktiviteterForDagen,
    required this.cardColors,
    required this.top10aktiviteter,
    required this.maxYValue,
  });

  final betweenSpace = 0.0;
  final double barWidth = 20;
  addDoubleToList(Map<String, bool> inputMap, double doubleSize) {
    Map<String, double> outputMap = {};
    inputMap.forEach((key, value) {
      outputMap[key] = value ? doubleSize : 0.0;
    });
    // print(outputMap);
    return outputMap;
  }

  BarChartGroupData generateGroupData(
      int x,
      Map<String, double> top10aktiviteterMedDouble,
      double barWidth,
      List<String> top10aktiviteter,
      double betweenSpace) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barsSpace: 15,
      barRods: List.generate(top10aktiviteter.length, (index) {
        double fromY = index == 0
            ? 0
            : top10aktiviteter
                    .take(index)
                    .map((activity) =>
                        top10aktiviteterMedDouble[activity] ?? 0.0)
                    .reduce((a, b) => a + b) +
                (index * betweenSpace);
        double toY =
            fromY + (top10aktiviteterMedDouble[top10aktiviteter[index]] ?? 0.0);
        return BarChartRodData(
          fromY: fromY,
          toY: toY,
          color: cardColors[index % cardColors.length],
          width: barWidth,
          borderRadius: BorderRadius.zero,
        );
      }),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
    String text;
    switch (value.toInt()) {
      case 5:
        text = 'På dagen';
        break;
      case 4:
        text = '1 dag før';
        break;
      case 3:
        text = '2 dage før';
        break;
      case 2:
        text = '3 dage før';
        break;
      case 1:
        text = '4 dage før';
        break;
      case 0:
        text = '5 dage før';
      default:
        text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Aktiviteter',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          LegendsListWidget(
            legends: [
              Legend(top10aktiviteter[0], cardColors[0]),
              Legend(top10aktiviteter[1], cardColors[1]),
              Legend(top10aktiviteter[2], cardColors[2]),
              Legend(top10aktiviteter[3], cardColors[3]),
              Legend(top10aktiviteter[4], cardColors[4]),
              Legend(top10aktiviteter[5], cardColors[5]),
              Legend(top10aktiviteter[6], cardColors[6]),
              Legend(top10aktiviteter[7], cardColors[7]),
              Legend(top10aktiviteter[8], cardColors[8]),
              Legend(top10aktiviteter[9], cardColors[9]),
            ],
          ),
          const SizedBox(height: 5),
          AspectRatio(
            aspectRatio: 0.75,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 30,
                    ),
                  ),
                ),
                barTouchData: BarTouchData(enabled: false),
                borderData: FlBorderData(show: true),
                gridData: const FlGridData(show: true),
                barGroups: [
                  generateGroupData(
                      1,
                      addDoubleToList(
                          aktiviteterForDagen.values.elementAt(4), 1.0),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                  generateGroupData(
                      2,
                      addDoubleToList(
                          aktiviteterForDagen.values.elementAt(3), 1.0),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                  generateGroupData(
                      3,
                      addDoubleToList(
                          aktiviteterForDagen.values.elementAt(2), 1.0),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                  generateGroupData(
                      4,
                      addDoubleToList(
                          aktiviteterForDagen.values.elementAt(1), 1.0),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                  generateGroupData(
                      5,
                      addDoubleToList(
                          aktiviteterForDagen.values.elementAt(0), 1.0),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                ],
                maxY: maxYValue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBarChartSamlet extends StatelessWidget {
  List<Map<String, Map<String, bool>>> listOfaktiviteterForDagen;
  List<String> top10aktiviteter;
  List<Color> cardColors;
  double maxYValue;
  CustomBarChartSamlet({
    super.key,
    required this.listOfaktiviteterForDagen,
    required this.cardColors,
    required this.top10aktiviteter,
    required this.maxYValue,
  });

  final betweenSpace = 0.0;
  final double barWidth = 20;
  addDoubleToList(List<Map<String, Map<String, bool>>> inputList,
      double doubleSize, int daysPrior) {
    if (daysPrior >= inputList.length) {
      throw IndexError(daysPrior, inputList);
    }

    Map<String, Map<String, bool>> days = inputList[daysPrior];
    List<String> keys = days.keys.toList();
    Map<String, double> outputMap = {};

    for (int i = 0; i < keys.length; i++) {
      Map<String, bool>? dayActivities = days[keys[i]];
      dayActivities?.forEach((activity, completed) {
        outputMap[activity] =
            (outputMap[activity] ?? 0) + (completed ? 1.0 : 0.0);
      });
    }

    print(outputMap);
    return outputMap;
  }

  BarChartGroupData generateGroupData(
      int x,
      Map<String, double> top10aktiviteterMedDouble,
      double barWidth,
      List<String> top10aktiviteter,
      double betweenSpace) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barsSpace: 15,
      barRods: List.generate(top10aktiviteter.length, (index) {
        double fromY = index == 0
            ? 0
            : top10aktiviteter
                    .take(index)
                    .map((activity) =>
                        top10aktiviteterMedDouble[activity] ?? 0.0)
                    .reduce((a, b) => a + b) +
                (index * betweenSpace);
        double toY =
            fromY + (top10aktiviteterMedDouble[top10aktiviteter[index]] ?? 0.0);
        return BarChartRodData(
          fromY: fromY,
          toY: toY,
          color: cardColors[index % cardColors.length],
          width: barWidth,
          borderRadius: BorderRadius.zero,
        );
      }),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
    String text;
    switch (value.toInt()) {
      case 5:
        text = 'På dagen';
        break;
      case 4:
        text = '1 dag før';
        break;
      case 3:
        text = '2 dage før';
        break;
      case 2:
        text = '3 dage før';
        break;
      case 1:
        text = '4 dage før';
        break;
      case 0:
        text = '5 dage før';
      default:
        text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Aktiviteter',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          LegendsListWidget(
            legends: [
              Legend(top10aktiviteter[0], cardColors[0]),
              Legend(top10aktiviteter[1], cardColors[1]),
              Legend(top10aktiviteter[2], cardColors[2]),
              Legend(top10aktiviteter[3], cardColors[3]),
              Legend(top10aktiviteter[4], cardColors[4]),
              Legend(top10aktiviteter[5], cardColors[5]),
              Legend(top10aktiviteter[6], cardColors[6]),
              Legend(top10aktiviteter[7], cardColors[7]),
              Legend(top10aktiviteter[8], cardColors[8]),
              Legend(top10aktiviteter[9], cardColors[9]),
            ],
          ),
          const SizedBox(height: 5),
          AspectRatio(
            aspectRatio: 0.65,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 30,
                    ),
                  ),
                ),
                barTouchData: BarTouchData(enabled: false),
                borderData: FlBorderData(show: true),
                gridData: const FlGridData(show: true),
                barGroups: [
                  // generateGroupData(
                  //     0,
                  //     addDoubleToList(
                  //         aktiviteterForDagen.values.elementAt(5), 1.0),
                  //     barWidth,
                  //     top10aktiviteter,
                  //     0.0),
                  generateGroupData(
                      1,
                      addDoubleToList(listOfaktiviteterForDagen, 1.0, 4),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                  generateGroupData(
                      2,
                      addDoubleToList(listOfaktiviteterForDagen, 1.0, 3),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                  generateGroupData(
                      3,
                      addDoubleToList(listOfaktiviteterForDagen, 1.0, 2),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                  generateGroupData(
                      4,
                      addDoubleToList(listOfaktiviteterForDagen, 1.0, 1),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                  generateGroupData(
                      5,
                      addDoubleToList(listOfaktiviteterForDagen, 1.0, 0),
                      barWidth,
                      top10aktiviteter,
                      0.0),
                ],
                maxY: maxYValue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
