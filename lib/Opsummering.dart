import 'package:flutter/material.dart';
import 'navigationbars.dart';
import 'opsummering.dart';
import 'homepage.dart';
import 'globals.dart' as globals;
import 'painjournal.dart';
import 'loginpage.dart';
import 'radardiagram.dart';
import 'punktdiagram.dart';
import 'laromdinsmerteMellemPage.dart';

class Opsummering extends StatefulWidget {
  const Opsummering({super.key});

  @override
  State<Opsummering> createState() => _OpsummeringState();
}

class _OpsummeringState extends State<Opsummering> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(pagename: "Opsummering"),
      bottomNavigationBar: const Bottomappbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Margen ud til kanten
        child: Column(
          children: [
            Spacer(), // Tomt mellemrum før første række
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Ensartet spacing mellem knapper
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return RadarChartExample();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.radar_rounded, size: 24),
                        SizedBox(width: 8),
                        Text('Radardiagram', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Punktdiagram();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.show_chart, size: 24),
                        SizedBox(width: 8),
                        Text('Punktdiagram', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Laromdinsmerte();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.insert_chart_outlined_outlined, size: 24),
                        SizedBox(width: 8),
                        Text('Lær om din smerte',
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
