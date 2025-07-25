// dialog_utils.dart
import 'package:flutter/material.dart';

void showSuccessDialog(BuildContext context, {String message = "Login successful!"}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const  SizedBox(height: 10),
          const  Text(
              "Success",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          const  SizedBox(height: 5),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:const Text("OK"),
          ),
        ],
      );
    },
  );
}

void showErrorDialog(BuildContext context, {String message = "Incorrect password. Please try again."}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          const  Icon(Icons.cancel, size: 80, color: Colors.red),
          const  SizedBox(height: 10),
          const  Text(
              "Error",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          const  SizedBox(height: 5),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:const Text("OK"),
          ),
        ],
      );
    },
  );
}