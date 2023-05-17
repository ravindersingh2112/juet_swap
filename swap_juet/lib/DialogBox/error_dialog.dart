import 'package:flutter/material.dart';
import 'package:swap_juet/WelcomeScreen/welcome_screen.dart';


class ErrorAlertDialog extends StatelessWidget {

  final String message;

  const ErrorAlertDialog({required this.message});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: [
        ElevatedButton(
            onPressed: ()
            {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WelcomeScreen()));
            },
            child: const Center(
              child: Text('Ok'),
            )
        ),
      ],
    );
  }
}
