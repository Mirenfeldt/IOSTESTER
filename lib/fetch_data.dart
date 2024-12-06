import 'package:flutter/material.dart';
import 'package:raman/homepage.dart';
import 'package:raman/navigationbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:raman/opsummering.dart';

int prevalenceLength = 14;
int fetchVASDatasize = 31;
int fetchGodeOgDaarligeDageDataSize = 31;
int dataLengthForAktivitiesOnGoodAndBadDays = 5;
double gnsSmerte = 5;
double gnsSmerteUpperLimit = 0;
double gnsSmerteLowerLimit = 0;
int gnsInputDataLength = 7;
double painValue = 5;
double sleepValue = 5;
double socialValue = 5;
double moodValue = 5;
double activityValue = 5;
double smerteUge = 5;
double humorUge = 5;
double aktivitetUge = 5;
double socialUge = 5;
double sovnUge = 5;
double smerteManed = 5;
double humorManed = 5;
double aktivitetManed = 5;
double socialManed = 5;
double sovnManed = 5;

String userUID = FirebaseAuth.instance.currentUser!.uid;
Map<String, dynamic> smerteData = {};
Map<String, dynamic> sleepData = {};
Map<String, dynamic> socialData = {};
Map<String, dynamic> moodData = {};
Map<String, dynamic> aktivitetsData = {};
Map<String, dynamic> activityPrevalance = {};
Map<String, bool> activitiesBoolMap = {};
List<MapEntry<String, int>> activityPrevalanceSortedEntries = [];
List<Map<String, Map<String, bool>>> senesteDagesAktiviteter = [];
List<String> godeDage = [];
List<String> badDays = [];
List<Map<String, double>> godeDageVas = [];
List<Map<String, double>> badDaysVas = [];
List<Map<String, Map<String, bool>>> dataGodeDageForUseInApp = [];
List<Map<String, Map<String, bool>>> dataBadDaysForUseInApp = [];
bool dataFetched = false;

class LoadingDataPage extends StatefulWidget {
  int pageIndex = 0;
  bool isLoading = true;
  //start of punktdiagram fetching
  double painValue = 0;
  double sleepValue = 0;
  double socialValue = 0;
  double moodValue = 0;
  double activityValue = 0;
  double smerteUge = 0;
  double humorUge = 0;
  double aktivitetUge = 0;
  double socialUge = 0;
  double sovnUge = 0;
  double smerteManed = 0;
  double humorManed = 0;
  double aktivitetManed = 0;
  double socialManed = 0;
  double sovnManed = 0;

  LoadingDataPage({super.key, required this.pageIndex});

  @override
  State<LoadingDataPage> createState() => _LoadingDataPageState();
}

class _LoadingDataPageState extends State<LoadingDataPage> {
  bool isLoading = true;
  DateTime now = DateTime.now();
  String userUID = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _fetchData() async {
    int j = 0;
    int k = 0;
    godeDage = [];
    badDays = [];
    dataGodeDageForUseInApp = [];
    dataBadDaysForUseInApp = [];
    godeDageVas = [];
    badDaysVas = [];
    // print("Fetch started");

    Map<String, dynamic> dataGodeDage = {};
    Map<String, dynamic> dataBadDays = {};

    while (true) {
      // print("Gode dårlige dage started");

      try {
        DocumentSnapshot docSnapShotGodeDage = await FirebaseFirestore.instance
            .collection("users")
            .doc(userUID)
            .collection("LærOmDinSmerte")
            .doc("GodeDage")
            .get();

        DocumentSnapshot docSnapShotDarligeDage = await FirebaseFirestore
            .instance
            .collection("users")
            .doc(userUID)
            .collection("LærOmDinSmerte")
            .doc("DårligeDage")
            .get();

        CollectionReference colRefPainJournalVAS = FirebaseFirestore.instance
            .collection("users")
            .doc(userUID)
            .collection("dage");

        if (docSnapShotGodeDage.exists) {
          dataGodeDage = docSnapShotGodeDage.data() as Map<String, dynamic>;
          // print("doc1 exist");
          // print(dataGodeDage);
        }

        if (docSnapShotDarligeDage.exists) {
          dataBadDays = docSnapShotDarligeDage.data() as Map<String, dynamic>;
          // print("doc2 exist");
        }

        for (var i = 0; i < 90; i++) {
          DateTime date = DateTime.now().subtract(Duration(days: i));
          String dateString = DateFormat('yyyy-MM-dd').format(date);
          String printedString = DateFormat('dd-MM-yy').format(date);
          if (dataGodeDage.containsKey(dateString) &&
              dataGodeDage[dateString] is List) {
            godeDage.add(printedString);
            try {
              // print("I try for VAS");
              DocumentSnapshot docSnapVASScore = await colRefPainJournalVAS
                  .doc(dateString)
                  .collection("smertedagbog")
                  .doc("VAS")
                  .get();
              if (docSnapVASScore.exists) {
                // print("VAS-exists");
                Map<String, dynamic> VASscore =
                    docSnapVASScore.data() as Map<String, dynamic>;
                // print(VASscore);
                Map<String, double> convertedVAS = VASscore.map(
                  (key, value) {
                    if (value is double) {
                      return MapEntry(key, value);
                    } else {
                      return MapEntry(key, 0.0);
                    }
                  },
                );
                godeDageVas.add(convertedVAS);
                print(godeDageVas);
              }
            } catch (e) {}
            // Initialize nestedMap for each date
            Map<String, Map<String, bool>> nestedMap = {};
            for (var entry in dataGodeDage[dateString]) {
              entry.forEach((key, value) {
                if (value is Map<String, dynamic>) {
                  Map<String, bool> boolMap = {};
                  value.forEach((nestedKey, nestedValue) {
                    if (nestedValue is bool) {
                      boolMap[nestedKey] = nestedValue;
                    }
                  });
                  nestedMap[key] = boolMap;
                }
              });
            }

            dataGodeDageForUseInApp.add(nestedMap);

            print(dataGodeDageForUseInApp);

            j++;
            // print(j);
          }

          // print(i);

          if (j == 5) {
            // print("i break out of good loop");
            break;
          }
        }

        for (var i = 0; i < 90; i++) {
          DateTime date = DateTime.now().subtract(Duration(days: i));
          String dateString = DateFormat('yyyy-MM-dd').format(date);
          String printedString = DateFormat('dd-MM-yy').format(date);
          // print("date $dateString");
          if (dataBadDays.containsKey(dateString) &&
              dataBadDays[dateString] is List) {
            // print("jeg kan genkende lister");
            badDays.add(printedString);
            try {
              // print("I try for VAS");
              DocumentSnapshot docSnapVASScore = await colRefPainJournalVAS
                  .doc(dateString)
                  .collection("smertedagbog")
                  .doc("VAS")
                  .get();
              if (docSnapVASScore.exists) {
                // print("VAS-exists");
                Map<String, dynamic> VASscore =
                    docSnapVASScore.data() as Map<String, dynamic>;
                print(VASscore);
                Map<String, double> convertedVAS = VASscore.map(
                  (key, value) {
                    if (value is double) {
                      return MapEntry(key, value);
                    } else {
                      return MapEntry(key, 0.0);
                    }
                  },
                );
                badDaysVas.add(convertedVAS);
                // print(godeDageVas);
              }
            } catch (e) {}
            Map<String, Map<String, bool>> nestedMap = {};
            for (var entry in dataBadDays[dateString]) {
              entry.forEach((key, value) {
                if (value is Map<String, dynamic>) {
                  Map<String, bool> boolMap = {};
                  value.forEach((nestedKey, nestedValue) {
                    if (nestedValue is bool) {
                      boolMap[nestedKey] = nestedValue;
                    }
                  });
                  nestedMap[key] = boolMap;
                }
              });
            }

            dataBadDaysForUseInApp.add(nestedMap);
            // print(dataBadDaysForUseInApp);
            // print(badDays);
            k++;
            // print(k);
          }

          // print(i);
          // print(badDays);

          if (k == 5) {
            // print("i break out of bad loop");
            break;
          }
        }

        break;
      } catch (e) {
        print("Error fetching data: $e");
        break;
      }
    }

    gnsSmerte = 0;
    gnsSmerteUpperLimit = 0;
    gnsSmerteLowerLimit = 0;
    senesteDagesAktiviteter = [];
    int l = 0;

    String dagsDato = DateFormat('yyyy-MM-dd').format(now);
    for (var i = 0; i < gnsInputDataLength; i++) {
      DateTime date = now.subtract(Duration(days: i));

      String dateString = DateFormat('yyyy-MM-dd').format(date);
      DocumentSnapshot docSnapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("dage")
          .doc(dateString)
          .collection("smertedagbog")
          .doc("VAS")
          .get();
      if (docSnapShot.exists) {
        Map<String, dynamic> data = docSnapShot.data() as Map<String, dynamic>;
        gnsSmerte = gnsSmerte + data['Smerte']?.toDouble();
        l++;
      }
    }

    if (l != 0) {
      gnsSmerte = gnsSmerte / l;
      gnsSmerteUpperLimit = gnsSmerte + (gnsSmerte * 0.33);
      gnsSmerteLowerLimit = gnsSmerte - (gnsSmerte * 0.33);
      // print("gnsSmerte = $gnsSmerte");
      // print("gnsSmerteUpperLimit = $gnsSmerteUpperLimit");
      // print("gnsSmerteLowerLimit = $gnsSmerteLowerLimit");
    }

    int jUge = 0;
    for (var i = 0; i < 7; i++) {
      DateTime date = now.subtract(Duration(days: i));
      String dateString = DateFormat('yyyy-MM-dd').format(date);
      DocumentSnapshot docSnapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("dage")
          .doc(dateString)
          .collection("smertedagbog")
          .doc("VAS")
          .get();
      // print("getdata:");
      // print(i);
      if (docSnapShot.exists) {
        Map<String, dynamic> data = docSnapShot.data() as Map<String, dynamic>;
        smerteUge = smerteUge + data['Smerte']?.toDouble();
        humorUge = humorUge + data['Humør']?.toDouble();
        sovnUge = sovnUge + data['Søvn']?.toDouble();
        aktivitetUge = aktivitetUge + data['Aktivitetsniveau']?.toDouble();
        socialUge = socialUge + data['Social']?.toDouble();
        jUge++;
        // print("Snapshot exists:");
        // print(i);
      }
    }
    if (jUge != 0) {
      smerteUge = smerteUge / jUge;
      humorUge = humorUge / jUge;
      sovnUge = sovnUge / jUge;
      aktivitetUge = aktivitetUge / jUge;
      socialUge = socialUge / jUge;
    }
    int jManed = 0;
    for (var i = 0; i < 31; i++) {
      DateTime date = now.subtract(Duration(days: i));
      String dateString = DateFormat('yyyy-MM-dd').format(date);
      DocumentSnapshot docSnapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("dage")
          .doc(dateString)
          .collection("smertedagbog")
          .doc("VAS")
          .get();
      // print("getdataMManed:");
      // print(i);
      if (docSnapShot.exists) {
        Map<String, dynamic> data = docSnapShot.data() as Map<String, dynamic>;
        smerteManed = smerteManed + data['Smerte']?.toDouble();
        humorManed = humorManed + data['Humør']?.toDouble();
        sovnManed = sovnManed + data['Søvn']?.toDouble();
        aktivitetManed = aktivitetManed + data['Aktivitetsniveau']?.toDouble();
        socialManed = socialManed + data['Social']?.toDouble();
        jManed++;
        // print("SnapshotManed exists:");
        // print(i);
      }
    }

    if (jManed != 0) {
      smerteManed = smerteManed / jManed;
      humorManed = humorManed / jManed;
      sovnManed = sovnManed / jManed;
      aktivitetManed = aktivitetManed / jManed;
      socialManed = socialManed / jManed;
    }

    for (var i = 0; i <= dataLengthForAktivitiesOnGoodAndBadDays; i++) {
      DateTime date = now.subtract(Duration(days: i));
      String dateString = DateFormat('yyyy-MM-dd').format(date);
      DocumentSnapshot docSnapShot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("dage")
          .doc(dateString)
          .collection("smertedagbog")
          .doc("aktiviteter")
          .get();
      if (docSnapShot.exists) {
        Map<String, dynamic> data = docSnapShot.data() as Map<String, dynamic>;
        Map<String, Map<String, bool>> mellemMap = {};

// Assuming 'Aktivitetsliste' is the key for the map you want to extract
        if (data['Aktivitetsliste'] is Map<String, dynamic>) {
          Map<String, dynamic> aktivitetslisteDynamic =
              data['Aktivitetsliste'] as Map<String, dynamic>;
          Map<String, bool> aktivitetsliste = aktivitetslisteDynamic
              .map((key, value) => MapEntry(key, value as bool));
          if (aktivitetsliste is Map<String, bool>) {
            mellemMap[dateString] = aktivitetsliste;
            senesteDagesAktiviteter.add(mellemMap);
          }
        }
      } else {
        Map<String, Map<String, bool>> mellemMap = {};
        try {
          DocumentSnapshot docSnapShot = await FirebaseFirestore.instance
              .collection("users")
              .doc(userUID)
              .collection("AktivitetsOversigt")
              .doc("Aktiviteter")
              .get();
          if (docSnapShot.exists) {
            Map<String, dynamic> data =
                docSnapShot.data() as Map<String, dynamic>;
            Map<String, bool> boolMap =
                data["Aktiviteter"].map((key, value) => MapEntry(key, false));
            senesteDagesAktiviteter.add(mellemMap);
          }
        } catch (e) {}
      }
    }
    for (var i = fetchVASDatasize; i >= 0; i--) {
      // Loop for running through the database, starting from today's date and going backwards
      DateTime date = now.subtract(Duration(days: i));
      String dateString = DateFormat('yyyy-MM-dd').format(date);
      String dateWithoutYYYY = DateFormat('dd-MM').format(date);
      DocumentReference docRef = FirebaseFirestore
          .instance // Instance for the program to fetch data from the database
          .collection("users")
          .doc(userUID)
          .collection("dage")
          .doc(dateString)
          .collection("smertedagbog")
          .doc("VAS");
      DocumentSnapshot docSnapShot = await docRef.get();

      setState(() {
        if (docSnapShot.exists) {
          // When new data is acquired, save it at the appropriate data locations
          Map<String, dynamic> data =
              docSnapShot.data() as Map<String, dynamic>;
          smerteData.addEntries([MapEntry(dateWithoutYYYY, data["Smerte"])]);
          sleepData.addEntries([MapEntry(dateWithoutYYYY, data["Søvn"])]);
          socialData.addEntries([MapEntry(dateWithoutYYYY, data["Social"])]);
          moodData.addEntries([MapEntry(dateWithoutYYYY, data["Humør"])]);
          aktivitetsData.addEntries(
              [MapEntry(dateWithoutYYYY, data["Aktivitetsniveau"])]);
        } else {
          // Add null entries if the document does not exist
          smerteData.addEntries([MapEntry(dateWithoutYYYY, null)]);
          sleepData.addEntries([MapEntry(dateWithoutYYYY, null)]);
          socialData.addEntries([MapEntry(dateWithoutYYYY, null)]);
          moodData.addEntries([MapEntry(dateWithoutYYYY, null)]);
          aktivitetsData.addEntries([MapEntry(dateWithoutYYYY, null)]);
        }
      });
    }
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("dage")
          .doc(dagsDato)
          .collection("smertedagbog")
          .doc("VAS")
          .get();

      DocumentSnapshot documentSnapshot2 = await FirebaseFirestore.instance
          .collection("users")
          .doc(userUID)
          .collection("dage")
          .doc(dagsDato)
          .collection("smertedagbog")
          .doc("aktiviteter")
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        if (documentSnapshot2.exists) {
          DocumentSnapshot documentSnapshot3 = await FirebaseFirestore.instance
              .collection("users")
              .doc(userUID)
              .collection("AktivitetsOversigt")
              .doc("Aktiviteter")
              .get();
          Map<String, int> activitiesPrevalence = {};
          if (documentSnapshot3.exists) {
            activityPrevalance =
                documentSnapshot3.data() as Map<String, dynamic>;
            Map<String, dynamic> nestedMap = activityPrevalance['Aktiviteter'];

            // Convert to Map<String, int>
            activitiesPrevalence =
                nestedMap.map((key, value) => MapEntry(key, value as int));

            // Initialize activitiesPrevalence with zeros
            activitiesPrevalence = {for (var key in nestedMap.keys) key: 0};

            for (var i = 0; i < prevalenceLength; i++) {
              DateTime date = now.subtract(Duration(days: i));
              String prevalenceDate = DateFormat('yyyy-MM-dd').format(date);
              DocumentSnapshot documentSnapshot4 = await FirebaseFirestore
                  .instance
                  .collection("users")
                  .doc(userUID)
                  .collection("dage")
                  .doc(prevalenceDate)
                  .collection("smertedagbog")
                  .doc("aktiviteter")
                  .get();
              if (documentSnapshot4.exists) {
                Map<String, dynamic> dbbool =
                    documentSnapshot4.data() as Map<String, dynamic>;
                Map<String, dynamic> activitiesBoolNestedMap =
                    dbbool['Aktivitetsliste'];
                Map<String, bool> activitiesBool = activitiesBoolNestedMap
                    .map((key, value) => MapEntry(key, value as bool));

                activitiesBool.forEach((key, value) {
                  if (value == true) {
                    if (activitiesPrevalence.containsKey(key)) {
                      activitiesPrevalence[key] =
                          activitiesPrevalence[key]! + 1;
                    } else {
                      activitiesPrevalence[key] = 1;
                    }
                  }
                });
              }
            }

            // Sort the map by values in descending order
            activityPrevalanceSortedEntries = activitiesPrevalence.entries
                .toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            // Convert to Map<String, bool> with all values set to false
            activitiesBoolMap = {
              for (var entry in activityPrevalanceSortedEntries)
                entry.key: false
            };

            // Update activitiesBoolMap with values from the latest document
            Map<String, dynamic> dbbool =
                documentSnapshot2.data() as Map<String, dynamic>;
            Map<String, dynamic> activitiesBoolNestedMap =
                dbbool['Aktivitetsliste'];
            Map<String, bool> activitiesBool = activitiesBoolNestedMap
                .map((key, value) => MapEntry(key, value as bool));
            activitiesBool.forEach((key, value) {
              if (activitiesBoolMap.containsKey(key)) {
                activitiesBoolMap[key] = value;
              }
            });
          }
        }

        setState(() {
          painValue = data['Smerte']?.toDouble() ?? 5.0;
          sleepValue = data['Søvn']?.toDouble() ?? 5.0;
          socialValue = data['Social']?.toDouble() ?? 5.0;
          moodValue = data['Humør']?.toDouble() ?? 5.0;
          activityValue = data['Aktivitetsniveau']?.toDouble() ?? 5.0;
          isLoading = false;
        });
      } else {
        Map<String, int> activitiesPrevalence = {};
        DocumentSnapshot documentSnapshot3 = await FirebaseFirestore.instance
            .collection("users")
            .doc(userUID)
            .collection("AktivitetsOversigt")
            .doc("Aktiviteter")
            .get();
        if (documentSnapshot3.exists) {
          activityPrevalance = documentSnapshot3.data() as Map<String, dynamic>;
          Map<String, dynamic> nestedMap = activityPrevalance['Aktiviteter'];

          // Convert to Map<String, int>
          activitiesPrevalence =
              nestedMap.map((key, value) => MapEntry(key, value as int));

          // Initialize activitiesPrevalence with zeros
          activitiesPrevalence = {for (var key in nestedMap.keys) key: 0};

          for (var i = 0; i < prevalenceLength; i++) {
            DateTime date = now.subtract(Duration(days: i));
            String prevalenceDate = DateFormat('yyyy-MM-dd').format(date);
            DocumentSnapshot documentSnapshot4 = await FirebaseFirestore
                .instance
                .collection("users")
                .doc(userUID)
                .collection("dage")
                .doc(prevalenceDate)
                .collection("smertedagbog")
                .doc("aktiviteter")
                .get();
            if (documentSnapshot4.exists) {
              Map<String, dynamic>? dbbool =
                  documentSnapshot4.data() as Map<String, dynamic>?;
              if (dbbool != null && dbbool.containsKey('Aktivitetsliste')) {
                Map<String, dynamic> activitiesBoolNestedMap =
                    dbbool['Aktivitetsliste'];
                Map<String, bool> activitiesBool = activitiesBoolNestedMap
                    .map((key, value) => MapEntry(key, value as bool));

                activitiesBool.forEach((key, value) {
                  if (value == true) {
                    if (activitiesPrevalence.containsKey(key)) {
                      activitiesPrevalence[key] =
                          activitiesPrevalence[key]! + 1;
                    } else {
                      activitiesPrevalence[key] = 1;
                    }
                  }
                });
              }
            }
          }

          // Sort the map by values in descending order
          activityPrevalanceSortedEntries = activitiesPrevalence.entries
              .toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          // Convert to Map<String, bool> with all values set to false
          activitiesBoolMap = {
            for (var entry in activityPrevalanceSortedEntries) entry.key: false
          };

          // Update activitiesBoolMap with values from the latest document
          Map<String, dynamic>? dbbool =
              documentSnapshot2.data() as Map<String, dynamic>?;
          if (dbbool != null && dbbool.containsKey('Aktivitetsliste')) {
            Map<String, dynamic> activitiesBoolNestedMap =
                dbbool['Aktivitetsliste'];
            Map<String, bool> activitiesBool = activitiesBoolNestedMap
                .map((key, value) => MapEntry(key, value as bool));
            activitiesBool.forEach((key, value) {
              if (activitiesBoolMap.containsKey(key)) {
                activitiesBoolMap[key] = value;
              }
            });
          }
        }

        setState(() {
          isLoading = false;
          dataFetched = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }

    setState(() {
      // When data is finished loading, set the bool to false so that the page can be rendered
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 228),
        appBar: Topappbar(pagename: "Indlæser data"),
        body: const Center(child: CircularProgressIndicator()),
      );
    } else if (widget.pageIndex == 1) {
      return Opsummering();
    }
    return Homepage();
  }
}
