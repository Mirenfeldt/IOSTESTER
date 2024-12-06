import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:raman/homepage.dart';
//  import 'package:raman/homepage.dart';
import 'firebase_options.dart';
//import 'package:raman/painjournal.dart';
//import 'homepage.dart';
import 'loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'notifications.dart';
import 'fetch_data.dart' as data;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic test',

        importance:
            NotificationImportance.Max, // Ensure channel importance is High
        defaultRingtoneType: DefaultRingtoneType.Notification,
        enableVibration: true,
        channelShowBadge: true,
      ),
    ],
    debug: true,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

Future<Widget> loginOrHome() async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return data.LoadingDataPage(
      pageIndex: 0,
    );
  } else {
    return LoginPage();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RAMAN',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: Homepage(),
      home: FutureBuilder<Widget>(
        future: loginOrHome(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Error occurred')),
            );
          } else {
            return snapshot.data!;
          }
        },
      ),
    );
  }
}
