import 'package:flutter/material.dart';

void showAlertDialog(context, String title, String message, onPressed,
    {String noText = "Cancel", String yesText = "Confirm"}) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(message),
    actionsAlignment: MainAxisAlignment.spaceEvenly,
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          noText,
          style: const TextStyle(color: Colors.black54),
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
        onPressed: onPressed,
        child: Text(
          yesText,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
  showDialog(context: context, builder: (_) => alertDialog);
}
