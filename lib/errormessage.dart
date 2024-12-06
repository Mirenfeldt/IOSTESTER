import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final String errorMessage;

  const MyDialog({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Fejl!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(errorMessage),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

Future<void> showMyDialog(BuildContext context, String errorMessage) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return MyDialog(errorMessage: errorMessage);
    },
  );
}
