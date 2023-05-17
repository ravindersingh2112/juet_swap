import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swap_juet/DialogBox/error_dialog.dart';
import 'package:swap_juet/ForgetPassword/forget_password.dart';
import 'package:swap_juet/HomeScreen/home_screen.dart';
import 'package:swap_juet/LoginScreen/login_screen.dart';
import 'package:swap_juet/SignupScreen/background.dart';
import 'package:swap_juet/Widgets/already_have_an_account_check.dart';
import 'package:swap_juet/Widgets/rounded_button.dart';
import 'package:swap_juet/Widgets/rounded_input_field.dart';
import 'package:swap_juet/Widgets/rounded_password_field.dart';

import '../Widgets/global_var.dart';
class SignupBody extends StatefulWidget {


  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {

  String userPhotoUrl = '';
  File? _image;
  bool _isLoading = false;
  final signUpFormKey= GlobalKey<FormState>();


  final TextEditingController  _nameController = TextEditingController();
  final TextEditingController  _emailController = TextEditingController();
  final TextEditingController  _passwordController = TextEditingController();
  final TextEditingController  _phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;


  void _getFromCamera()async{
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _getFromGallery()async{
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }


  void _cropImage(filePath) async{
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    if(croppedImage != null)
      {
        setState(() {
        _image = File(croppedImage.path);
        });
      }
  }

  void _showImageDialog()
  {
    showDialog(context: context, builder: (context)
    {
     return AlertDialog(
       title: const Text('Please choose an option'),
       content: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           InkWell(
             onTap: (){
              _getFromCamera();
             },
             child: Row(
               children: const [
                 Padding(
                     padding: EdgeInsets.all(4.0),
                   child: Icon(
                     Icons.camera,
                     color: Colors.purple,
                   ),
                 ),
                 Text(
                   'Camera',
                   style: TextStyle(
                     color: Colors.purple,
                   ),
                 ),
               ],
             ),
           ),

           InkWell(
             onTap: (){
               _getFromGallery();
             },
             child: Row(
               children: const [
                 Padding(
                   padding: EdgeInsets.all(4.0),
                   child: Icon(
                     Icons.image,
                     color: Colors.purple,
                   ),
                 ),
                 Text(
                   'Gallery',
                   style: TextStyle(
                     color: Colors.purple,
                   ),
                 ),
               ],
             ),
           ),
         ],

       ),
     );
    });
  }

  void submitFormOnSignUp()async{
    final isValid = signUpFormKey.currentState!.validate();
    if(isValid)
    {
      if(_image == null)
        {
          showDialog(
            context: context,
            builder: (context)
              {
                return ErrorAlertDialog(message: 'Please pick an image');
              }
          );
          return;
        }
      setState(() {
        _isLoading = true;
      });
      try
      {
        await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim().toLowerCase(),
            password: _passwordController.text.trim(),
        );
        final User? user = _auth.currentUser;
        uid = user!.uid;

        final ref = FirebaseStorage.instance.ref().child('userImages').child(uid + '.jpg');
        await ref.putFile(_image!);
        userPhotoUrl =  await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(uid).set(
            {
              'userName' : _nameController.text.trim(),
              'id' : uid,
              'userNumber' : _phoneController.text.trim(),
              'userEmail' : _emailController.text.trim(),
              'userImage' : userPhotoUrl,
              'time' : DateTime.now(),
              'status' : 'approved',
            }
        );
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context)=> HomeScreen())
        );
      }
      catch(error)
    {
      setState(() {
        _isLoading = false;
      });
      ErrorAlertDialog(message: error.toString(),);
    }

    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width,
           screenHeight = MediaQuery.of(context).size.height;
    return SignupBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: signUpFormKey,
              child: InkWell(
                onTap: (){
                  //method
                  _showImageDialog();

                },
                child: CircleAvatar(
                  radius: screenWidth *0.20,
                  backgroundColor: Colors.white24,
                  backgroundImage: _image == null?null : FileImage(_image!),
                  child: _image == null ? Icon(
                    Icons.camera_enhance,
                    size: screenWidth*0.18,
                    color: Colors.black54,
                  )
                      : null,

                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02,),
            RoundedInputField(hintText: 'Name',
                icon: Icons.person,
                onChanged: (value)
                {
                  _nameController.text=value;
                }

            ),
            RoundedInputField(hintText: 'Email',
                icon: Icons.email,
                onChanged: (value)
                {
                  _emailController.text=value;
                }

            ),
            RoundedInputField(hintText: 'Phone',
                icon: Icons.phone,
                onChanged: (value)
                {
                  _phoneController.text=value;
                }

            ),
            RoundedPasswordField(
              onChanged: (value)
              {
                _passwordController.text =value;
              },

            ),
            const SizedBox(height: 5,),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgetPassword()));
                },
                child: const Text('Forget Password?',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
              ),
            ),
            _isLoading?
                Center(
                  child: Container(
                    width: 70,
                    height: 72,
                    child: const CircularProgressIndicator(),
                  ),
                )
                :
                RoundedButton(
                    text: 'Sign Up',
                    press: ()
                {
                  submitFormOnSignUp();
                }
                ),


            SizedBox(height: screenHeight * 0.03,),

            AlreadyHaveAnAccountCheck(
              login: false,
              press : (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
            }
            ),


          ],
        ),
      ),
    );
  }
}
