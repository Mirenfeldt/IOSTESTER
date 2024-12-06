import 'package:flutter/material.dart';
import 'package:raman/painjournal.dart';
import 'navigationbars.dart';
import 'notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'fetch_data.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    // AwesomeNotifications().actionStream.listen((receivedNotification) {
    //   // Handle notification action
    // });
    //setupNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(pagename: "Hjem"),
      bottomNavigationBar: const Bottomappbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Margen ud til kanten
        child: Column(
          children: [
            const Spacer(), // Tomt mellemrum før første række
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Ensartet spacing mellem knapper
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Opacity(
                            opacity: 0.25,
                            child: Icon(Icons.school_rounded, size: 140)),

                        // SizedBox(width: 8),
                        Text('E-læring',
                            style: const TextStyle(
                              fontSize: 22,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Mellemrum mellem knapper
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const PainJournal();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Opacity(
                          opacity: 0.25,
                          child: Icon(Icons.menu_book, size: 140),
                        ),
                        // SizedBox(width: 8),
                        Text('Smerte-\ndagbog',
                            style: TextStyle(
                              fontSize: 22,
                            )),
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Opacity(
                          opacity: 0.25,
                          child: Icon(Icons.fitness_center, size: 140),
                        ),
                        // SizedBox(width: 8),
                        Text('Øvelser',
                            style: TextStyle(
                              fontSize: 22,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Opacity(
                          opacity: 0.25,
                          child: Icon(Icons.bookmark_added_rounded, size: 140),
                        ),
                        // SizedBox(width: 8),
                        Text(
                          'Konsultations-\nlogbog',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Opacity(
                          opacity: 0.25,
                          child: Icon(Icons.people, size: 140),
                        ),
                        // SizedBox(width: 8),
                        Text('Patienthistorier',
                            style: TextStyle(
                              fontSize: 22,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Opacity(
                            opacity: 0.25,
                            child: Icon(Icons.my_library_books, size: 140)),
                        // SizedBox(width: 8),
                        Text('Metaforordbog', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
