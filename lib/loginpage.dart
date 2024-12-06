import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'errormessage.dart';
import 'globals.dart' as globals;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'fetch_data.dart' as data;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future _signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });
      //Denne linje "pusher replacement" i navigator, så man ikke retunerer til loginpage.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => data.LoadingDataPage(
            pageIndex: 0,
          ),
        ),
      );

      var UserUID = FirebaseAuth.instance.currentUser!
          .uid; // Vi gemmer UserUID (bliver nok smart senere;))

      // Handle successful sign-in
    } on FirebaseAuthException catch (e) {
      showMyDialog(context, 'Der skete en fejl under log-in');
    }
  }

  Future _register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("AktivitetsOversigt")
          .doc("Aktiviteter")
          .set({"Aktiviteter": globals.activitiesPrevalence});
      FirebaseFirestore.instance
          .collection("users") //Opretter bruger i databasen under users.
          .doc(FirebaseAuth.instance.currentUser!
              .uid) //Her oprettes de med et dokument med UUID'et
          .set({
        "email": FirebaseAuth
            .instance.currentUser!.email // Gemmer brugeres e-mail i field
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Center(
              child: Text(
                'MinSmerte',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 200),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                labelText: 'E-mail',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                labelText: 'Kodeord',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Log ind'),
            ),
            const SizedBox(height: 45.0),
            const Center(
              child: Text(
                'Har du ikke en konto?',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Center(
              child: Text(
                'Indtast e-mail og kodeord i ovenstående felter og tryk:',
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            TextButton(
              onPressed: _register,
              child: Text('Registrer konto'),
            ),
          ],
        ),
      ),
    );
  }
}
