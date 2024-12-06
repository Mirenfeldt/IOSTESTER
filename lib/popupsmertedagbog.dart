import 'package:flutter/material.dart';
import 'Opsummering.dart';
import 'homepage.dart';
import 'fetch_data.dart' as data;

class MyPopup extends StatelessWidget {
  final String title;
  final String message;

  const MyPopup({Key? key, required this.title, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(message),
          ],
        ),
      ),
      actions: [
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextButton(
                  child: const Text('Hjemmeskærm'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => data.LoadingDataPage(
                          pageIndex: 0,
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextButton(
                  child: const Text('Opsummering'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => data.LoadingDataPage(
                          pageIndex: 1,
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future showMyPopup(BuildContext context, String title, String message) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return MyPopup(title: title, message: message);
    },
  );
}
