import 'package:flutter/material.dart';
import 'package:swap_juet/LoginScreen/login_screen.dart';
import 'package:swap_juet/SignupScreen/signup_screen.dart';
import 'package:swap_juet/WelcomeScreen/background.dart';
import 'package:swap_juet/Widgets/rounded_button.dart';

class WelcomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WelcomeBackground(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: size.height * 0.3,
          ),
          Text(
            'Juet Swap',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              fontFamily: 'Signatra',
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          RoundedButton(
            text: 'Login',
            press: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context)=>LoginScreen()));
            },
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          RoundedButton(
            text: 'Sign Up',
            press: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context)=>SignupScreen()));
            },
          ),
        ],
      ),
    ));
  }
}
