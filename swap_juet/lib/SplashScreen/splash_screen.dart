import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swap_juet/HomeScreen/home_screen.dart';
import 'package:swap_juet/WelcomeScreen/welcome_screen.dart';



class SplashScreen extends StatefulWidget {


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer(){
    Timer(const Duration(seconds: 5),() async{
      if(FirebaseAuth.instance.currentUser != null)
        {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context)=> HomeScreen()));
        }
      else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context)=> WelcomeScreen()));
      }
    });
  }

  @override

  void initState() {

    super.initState();
    startTimer();
  }


  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent,Colors.cyanAccent,],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0,1.0],
            tileMode: TileMode.clamp,

          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/logo.png',width: 350.0,),

              ),

              const Center(
                child: Text('Juet Swap',style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Varela',
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
