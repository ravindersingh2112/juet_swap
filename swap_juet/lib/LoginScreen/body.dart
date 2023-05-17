import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swap_juet/DialogBox/error_dialog.dart';
import 'package:swap_juet/DialogBox/loadin_dialog.dart';
import 'package:swap_juet/ForgetPassword/forget_password.dart';
import 'package:swap_juet/HomeScreen/home_screen.dart';
import 'package:swap_juet/LoginScreen/background.dart';
import 'package:swap_juet/SignupScreen/signup_screen.dart';
import 'package:swap_juet/Widgets/already_have_an_account_check.dart';
import 'package:swap_juet/Widgets/rounded_button.dart';
import 'package:swap_juet/Widgets/rounded_input_field.dart';
import 'package:swap_juet/Widgets/rounded_password_field.dart';

class LoginBody extends StatefulWidget {


  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  void _login() async{
  showDialog(
      context: context,
      builder: (_)
      {
        return LoadingAlertDialog(message: 'Please wait',);
      }

     );
  User? cureentUser;
  
  await _auth.signInWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  ).then((auth){
    cureentUser = auth.user;
  }).catchError((error)
  {
    Navigator.pop(context);
    showDialog(context: context, builder: (context)
    {
      return ErrorAlertDialog(message: error.message.toString());
    });
  });

  if(cureentUser != null)
  {
  // ignore: use_build_context_synchronously
  Navigator.pop(context);
  // ignore: use_build_context_synchronously
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context)=>HomeScreen()));
  }
  else
  {
    print('error');
  }
  }



  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return LoginBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.04,),
            Image.asset('assets/icons/login.png',
            height: size.height * 0.32,),
            SizedBox(height: size.height *0.02,),
            RoundedInputField(
              hintText: 'Email',
              icon: Icons.person,
              onChanged: (value)
              {
              //email field
                _emailController.text =  value;
              },
            ),
            const SizedBox(height: 3,),
            RoundedPasswordField(
                onChanged: (value)
                {
                  _passwordController.text = value;
                }
            ),
            const SizedBox(height: 8,),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=> ForgetPassword()),
                );
                },
                child: const Text('Forgot Password',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,

                ),
                ),
              ),
            ),

            RoundedButton(
              text: 'Login',
              press: (){
              //login event
               _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty
                   ? _login()
                   : showDialog(
                 context: context,
                 builder: (context){
                   return ErrorAlertDialog(message: 'Please write Email and Password',);
                 }
               );
              },

            ),
            SizedBox(height: size.height*0.03,),

            AlreadyHaveAnAccountCheck(
                login: true,
              press: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>SignupScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
