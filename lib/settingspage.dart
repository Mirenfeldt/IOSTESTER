// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'loginpage.dart';
// import 'notifications.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   _SettingsPageState createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   TimeOfDay selectedTime = TimeOfDay(hour: 12, minute: 0);

//   Future<void> _signOut(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//       (Route<dynamic> route) => false,
//     );
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//     );
//     if (picked != null && picked != selectedTime) {
//       setState(() {
//         selectedTime = picked;
//       });
//       _setupNotification();
//     }
//   }

//   void _setupNotification() {
//     DateTime now = DateTime.now();
//     DateTime scheduleTime = DateTime(
//         now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
//     scheduleNotification(1, scheduleTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 243, 243, 228),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 243, 243, 228),
//         title: const Text('Indstillinger'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () => _signOut(context),
//               child: const Text('Log ud'),
//             ),
//             SizedBox(height: 20), // Add some space between the buttons
//             Text(
//               'Notifikationstidspunkt: ${selectedTime.format(context)}',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 20), // Add some space between the text and button
//             ElevatedButton(
//               onPressed: () => _selectTime(context),
//               child: const Text('Ændre notifikationstidspunkt'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loginpage.dart';
import 'notifications.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TimeOfDay selectedTime = TimeOfDay(hour: 20, minute: 0);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadSelectedTime();
  }

  Future<void> _loadSelectedTime() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (doc.exists) {
      Map<String, dynamic> nottid = doc.data() as Map<String, dynamic>;

      if (nottid['Notifikationstidspunkt_time'] != null) {
        int hour = doc['Notifikationstidspunkt_time'];
        int minute = doc['Notifikationstidspunkt_minut'];
        setState(() {
          selectedTime = TimeOfDay(hour: hour, minute: minute);
        });
      }
    } else {
      int hour = 20;
      int minute = 0;
      setState(() {
        selectedTime = TimeOfDay(hour: hour, minute: minute);
      });
    }
  }

  Future<void> _saveSelectedTime() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'Notifikationstidspunkt_time': selectedTime.hour,
      'Notifikationstidspunkt_minut': selectedTime.minute,
    });
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      await _saveSelectedTime();
      _setupNotification();
    }
  }

  void _setupNotification() {
    DateTime now = DateTime.now();
    DateTime scheduleTime = DateTime(
        now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
    scheduleNotification(1, scheduleTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 243, 228),
        title: const Text('Indstillinger'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Notifikationstidspunkt: ${selectedTime.format(context)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20), // Add some space between the text and button
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: const Text('Ændr notifikationstidspunkt'),
            ),
            SizedBox(height: 50),

            ElevatedButton(
              onPressed: () => _signOut(context),
              child: const Text('Log ud'),
            ),
          ],
        ),
      ),
    );
  }
}
