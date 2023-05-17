import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:swap_juet/ImageSliderScreen/image_slider_screen.dart';

import 'global_var.dart';
class ListViewWidget extends StatefulWidget {

  String docId, itemColor, img1, img2, img3, img4, img5, userImg, name, userId, itemModel, postId;
  String itemPrice, description, address, userNumber;
  DateTime date;
  double lat,lng;

  ListViewWidget({
    required this.docId,
    required this.itemColor,
    required this.img1,
    required this.img2,
    required this.img3,
    required this.img4,
    required this.img5,
    required this.userImg,
    required this.name,
    required this.date,
    required this.userId,
    required this.itemModel,
    required this.postId,
    required this.itemPrice,
    required this.description,
    required this.lat,
    required this.lng,
    required this.address,
    required this.userNumber,
});


  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}







class _ListViewWidgetState extends State<ListViewWidget> {


  Future<Future> showDialogForUpdateData(selectedDoc,oldUserName,oldPhoneNumber, oldItemPrice,oldItemName,oldItemColor,oldItemDescription)async
  {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return SingleChildScrollView(
            child: AlertDialog(
              title: const Text('Update Data',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Bebas',
                  letterSpacing: 2.0,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: oldUserName,
                    decoration: const InputDecoration(
                      hintText: 'Enter Your Name',
                    ),
                    onChanged: (value)
                    {
                      setState((){
                        oldUserName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5.0,),
                  TextFormField(
                    initialValue: oldPhoneNumber,
                    decoration: const InputDecoration(
                      hintText: 'Enter Your Phone Number',
                    ),
                    onChanged: (value)
                    {
                      setState((){
                        oldPhoneNumber = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5.0,),
                  TextFormField(
                    initialValue: oldItemPrice,
                    decoration: const InputDecoration(
                      hintText: 'Enter Item Price',
                    ),
                    onChanged: (value)
                    {
                      setState((){
                        oldItemPrice = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5.0,),
                  TextFormField(
                    initialValue: oldItemName,
                    decoration: const InputDecoration(
                      hintText: 'Enter Item Name',
                    ),
                    onChanged: (value)
                    {
                      setState((){
                        oldItemName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5.0,),
                  TextFormField(
                    initialValue: oldItemColor,
                    decoration: const InputDecoration(
                      hintText: 'Enter Item Color',
                    ),
                    onChanged: (value)
                    {
                      setState((){
                        oldItemColor = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5.0,),
                  TextFormField(
                    initialValue: oldItemDescription,
                    decoration: const InputDecoration(
                      hintText: 'Enter Item Description',
                    ),
                    onChanged: (value)
                    {
                      setState((){
                        oldItemDescription = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5.0,),


                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
                ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.pop(context);
                    updateProfileNameOnExistingPosts(oldUserName);
                    _updateUserName(oldUserName, oldPhoneNumber);

                    FirebaseFirestore.instance
                        .collection('items')
                        .doc(selectedDoc)
                        .update(
                        {
                        'userName': oldUserName,
                          'userNumber': oldPhoneNumber,
                          'itemPrice':oldItemPrice,
                          'itemModel': oldItemName,
                          'itemColor': oldItemColor,
                          'description': oldItemDescription,

                    }).catchError((onError)
                    {
                      print(onError);
                    });

                    Fluttertoast.showToast(
                        msg: 'The Data has been Updated',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.grey,
                      fontSize: 18.0,
                    );
                  },
                  child: const Text(
                    'Update Now',
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  updateProfileNameOnExistingPosts(oldUserName) async
  {
    await FirebaseFirestore.instance.collection('items').where
      ('id',isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get().then((snapshot)
    {
      for(int index=0;index<snapshot.docs.length; index++)
        {
          String userProfileNameInPost = snapshot.docs[index]['userName'];

          if(userProfileNameInPost != oldUserName)
            {
              FirebaseFirestore.instance.collection('items')
                  .doc(snapshot.docs[index].id)
                  .update({
                'userName': oldUserName,
              });
            }
        }
    });
  }

  Future _updateUserName(oldUserName,oldPhoneNumber) async
  {
    await FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'userName': oldUserName,
      'userNumber': oldPhoneNumber,
    });
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 16.0,
        shadowColor: Colors.white,
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyanAccent,Colors.blueAccent,],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              ),
          ),
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onDoubleTap: ()
                {
                  Navigator.pushReplacement(context, 
                      MaterialPageRoute(builder: (context)=> ImageSliderScreen(
                      title: widget.itemModel,
                      itemColor: widget.itemColor,
                      userNumber: widget.userNumber,
                        description: widget.description,
                        lat: widget.lat,
                        lng: widget.lng,
                        address: widget.address,
                        itemPrice: widget.itemPrice,
                        urlImage1: widget.img1,
                        urlImage2: widget.img2,
                        urlImage3: widget.img3,
                        urlImage4: widget.img4,
                        urlImage5: widget.img5,
                      )));
                },
                child: Image.network(
                  widget.img1,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8,),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        widget.userImg,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          widget.itemModel,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8,),
                        Text(
                          DateFormat(
                           'dd MMM, yyyy - hh:mm a'
                          ).format(widget.date).toString(),
                          style: const TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                    widget.userId != uid
                    ?
                        Padding(
                          padding: const EdgeInsets.only(right: 50.0),
                          child: Column(),
                        )
                        :
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: ()
                              {
                                showDialogForUpdateData(
                                  widget.docId,
                                  widget.name,
                                  widget.userNumber,
                                  widget.itemPrice,
                                  widget.itemModel,
                                  widget.itemColor,
                                  widget.description,
                                );
                              },
                              icon: const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Icon(
                                  Icons.edit_note,
                                  color: Colors.white,
                                  size: 27,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: ()
                              {
                                FirebaseFirestore.instance.collection('items')
                                    .doc(widget.postId)
                                    .delete();

                                Fluttertoast.showToast(
                                    msg: 'Post Deleted',
                                  toastLength: Toast.LENGTH_LONG,
                                  backgroundColor: Colors.grey,
                                  fontSize: 18.0,
                                );
                              },
                              icon: const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Icon(
                                    Icons.delete_forever,
                                    size: 22,
                                    color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
