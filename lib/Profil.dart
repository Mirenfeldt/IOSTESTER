import 'dart:math';

import 'package:flutter/material.dart';
import 'package:raman/navigationbars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
//import 'globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'popupsmertedagbog.dart';
import 'fetch_data.dart' as data;

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  double painValue = 5;
  double sleepValue = 5;
  double socialValue = 5;
  double moodValue = 5;
  double activityValue = 5;
  Map<String, bool> activitiesBoolMap = data.activitiesBoolMap;

  void generateRandomBoolValues(Map<String, bool> activitiesBoolMap) {
    Random random = Random();
    activitiesBoolMap.updateAll((key, value) => random.nextBool());
  }

  Future<void> _generateData() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("LærOmDinSmerte")
        .doc("DårligeDage")
        .delete();
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("LærOmDinSmerte")
        .doc("GodeDage")
        .delete();
    DateTime now = DateTime.now();
    for (var i = 0; i < 30; i++) {
      List<Map<String, Map<String, bool>>> senesteDagesAktiviteter = [];
      painValue =
          double.parse((Random().nextDouble() * 6).toStringAsFixed(1)) + 2;
      sleepValue =
          double.parse((Random().nextDouble() * 6).toStringAsFixed(1)) + 2;
      socialValue =
          double.parse((Random().nextDouble() * 6).toStringAsFixed(1)) + 2;
      moodValue =
          double.parse((Random().nextDouble() * 6).toStringAsFixed(1)) + 2;
      activityValue =
          double.parse((Random().nextDouble() * 6).toStringAsFixed(1)) + 2;
      generateRandomBoolValues(activitiesBoolMap);
      DateTime date = now.subtract(Duration(days: i));
      String dagsDato = DateFormat('yyyy-MM-dd').format(date);
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("dage")
          .doc(dagsDato)
          .collection("smertedagbog")
          .doc("VAS")
          .set(
        {
          "Smerte": painValue,
          "Søvn": sleepValue,
          "Social": socialValue,
          "Humør": moodValue,
          "Aktivitetsniveau": activityValue,
        },
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("dage")
          .doc(dagsDato)
          .collection("smertedagbog")
          .doc("aktiviteter")
          .set(
        {"Aktivitetsliste": activitiesBoolMap},
      );
      print(activitiesBoolMap);

      for (var j = 0; j <= 5; j++) {
        DateTime date = now.subtract(Duration(days: i + j));
        String dateString = DateFormat('yyyy-MM-dd').format(date);
        DocumentSnapshot docSnapShot = await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("dage")
            .doc(dateString)
            .collection("smertedagbog")
            .doc("aktiviteter")
            .get();
        if (docSnapShot.exists) {
          Map<String, dynamic> data =
              docSnapShot.data() as Map<String, dynamic>;
          Map<String, Map<String, bool>> mellemMap = {};

// Assuming 'Aktivitetsliste' is the key for the map you want to extract
          if (data['Aktivitetsliste'] is Map<String, dynamic>) {
            Map<String, dynamic> aktivitetslisteDynamic =
                data['Aktivitetsliste'] as Map<String, dynamic>;
            Map<String, bool> aktivitetsliste = aktivitetslisteDynamic
                .map((key, value) => MapEntry(key, value as bool));
            mellemMap[dateString] = aktivitetsliste;
            senesteDagesAktiviteter.add(mellemMap);
          }
        }
      }

      Map<String, Map<String, bool>> mellemMap = {};
      mellemMap[dagsDato] = activitiesBoolMap;
      List<Map<String, Map<String, bool>>> exportList = senesteDagesAktiviteter;
      exportList[0] = mellemMap;
      if (painValue < 4.5) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("LærOmDinSmerte")
            .doc("GodeDage")
            .set({dagsDato: exportList}, SetOptions(merge: true));
      } else if (painValue > 5.5) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("LærOmDinSmerte")
            .doc("DårligeDage")
            .set({dagsDato: exportList}, SetOptions(merge: true));
      }
    }
    print(painValue);
    showMyPopup(context, 'Godt arbejde!',
        "Vil du gå til hjemmeskærm eller opsummering?");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(pagename: "Profil"),
      bottomNavigationBar: BottomAppBar(),
      body: ElevatedButton(
          onPressed: () {
            _generateData();
            generateRandomBoolValues(activitiesBoolMap);
          },
          child: const Text('Tryk for at generere en måneds data')),
    );
  }
}
