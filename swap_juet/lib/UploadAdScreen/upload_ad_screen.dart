import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:swap_juet/DialogBox/loadin_dialog.dart';
import 'package:swap_juet/HomeScreen/home_screen.dart';
import 'package:uuid/uuid.dart';

import '../Widgets/global_var.dart';

class UploadAdScreen extends StatefulWidget {


  @override
  State<UploadAdScreen> createState() => _UploadAdScreenState();
}

class _UploadAdScreenState extends State<UploadAdScreen> {

  String postId = Uuid().v4();

  bool uploading = false, next = false;

  final List<File> _image = [];

  List<String> urlsList = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name = '';
  String phoneNo = '';

  double val = 0;



  String itemPrice='';
  String itemModel='';
  String itemColor='';
  String description='';



  chooseImage() async{
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
  }
  
  Future uploadFile() async{
    int i = 1;
    for(var img in _image)
      {
        setState(() {
          val = i / _image.length;
        });
        
        var ref = FirebaseStorage.instance.ref().child('image/${Path.basename(img.path)}');

        await ref.putFile(img).whenComplete(() async
        {
          await ref.getDownloadURL().then((value){
          urlsList.add(value);
          i++;
          });
        }
        );
      }
  }


  getNameOfUser()
  {
    FirebaseFirestore.instance.collection('users')
        .doc(uid)
        .get()
        .then((snapshot) async{
          if(snapshot.exists)
            {
              setState(() {
                name = snapshot.data()!['userName'];
                phoneNo = snapshot.data()!['userNumber'];
              });
            }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNameOfUser();


  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent,Colors.cyanAccent,],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0,1.0],
            tileMode: TileMode.clamp,
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent,Colors.cyanAccent,],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp,
                )
            ),
          ),
          title:  Text(
            next ? 'Please write Item Info' : 'Choose Item Images',
          style: const TextStyle(
            color: Colors.black54,
            fontFamily: 'Signatra',
            fontSize: 33, 
          ),
        ),
          actions: [
            next ? Container()
                 : ElevatedButton(
                    onPressed: ()
                    {
                      if(_image.length == 5)
                      {
                        setState(() {
                          uploading = true;
                          next = true;
                        });
                      }
                      else{
                        Fluttertoast.showToast(
                          msg: 'Please Select 5 Images Only',
                        gravity: ToastGravity.CENTER,
                        );
                      }
                     },
      child: const Text(
          'Next',
            style:TextStyle(
              fontSize: 19,
              color: Colors.black54,
              fontFamily: 'Varela',
            ),
      ) ,
      ),
          ],
        ),
        
        
        body: next 
            ? 
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 5,),
                    TextField(
                      decoration: const InputDecoration(hintText: 'Enter Item Price',),
                      onChanged: (value)
                        {
                          itemPrice = value;
                        },
                    ),
                    const SizedBox(height: 5,),
                    TextField(
                      decoration: const InputDecoration(hintText: 'Item Name',),
                      onChanged: (value)
                      {
                        itemModel = value;
                      },
                    ),
                    const SizedBox(height: 5,),
                    TextField(
                      decoration: const InputDecoration(hintText: 'Item Color',),
                      onChanged: (value)
                      {
                        itemColor = value;
                      },
                    ),
                    const SizedBox(height: 5,),
                    TextField(
                      decoration: const InputDecoration(hintText: 'Item Description',),
                      onChanged: (value)
                      {
                        description = value;
                      },
                    ),

                    const SizedBox(height: 15,),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton(
                        onPressed: ()
                        {
                          showDialog(
                              context: context,
                              builder: (context)
                              {
                               return LoadingAlertDialog(
                                   message: 'Uploading',
                               );
                              });
                          uploadFile().whenComplete(()
                          {
                            FirebaseFirestore.instance
                                .collection('items')
                                .doc(postId).set(
                              {
                                'userName': name,
                                'id': _auth.currentUser!.uid,
                                'postId': postId,
                                'userNumber': phoneNo,
                                'itemPrice': itemPrice,
                                'itemModel': itemModel,
                                'itemColor': itemColor,
                                'description': description,
                                'urlImage1': urlsList[0].toString(),
                                'urlImage2': urlsList[1].toString(),
                                'urlImage3': urlsList[2].toString(),
                                'urlImage4': urlsList[3].toString(),
                                'urlImage5': urlsList[4].toString(),
                                'imgPro': userImageUrl,
                                'lat': position!.latitude,
                                'lng': position!.longitude,
                                'address': completeAddress,
                                'time': DateTime.now(),
                                'status': 'approved',


                              });
                            Fluttertoast.showToast(
                                msg: 'Data Added Successfully',
                            );
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=> HomeScreen()));
                          }).catchError((onError){
                            print(onError);
                          });
                        },
                        child: const Text(
                          'Upload',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            )
            : 
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  child: GridView.builder(
                    itemCount: _image.length+1,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3
                    ),
                    itemBuilder: (context,index){
                      return index == 0 ?
                          Center(
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: ()
                              {
                              !uploading ? chooseImage() : null;
                              },
                            ),
                          )
                          :
                          Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(_image[index -1]),
                                fit: BoxFit.cover,
                              )
                            ),
                          );
                    },
                  ),
                ),
                uploading
                ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                          'Uploading..',
                        style: TextStyle(
                            fontSize:20,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ),
                )
                    :
                    Container(),
              ],
            ),
      ),
    );
  }
}
