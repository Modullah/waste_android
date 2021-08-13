import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:waste/screens/gallery.dart';
import 'dart:io';

class List extends StatefulWidget {
  const List({
    Key? key,
  }) : super(key: key);
  //final Function (String imageUrl) onFileChanged;  required this.onFileChanged
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
  var loading = true;
  File? image; //File
  var url;

  // Future pickImage(ImageSource source) async {
  //   final image = await ImagePicker().pickImage(source: source);
  //   final imagePath = File(image!.path);
  //   Reference reference =
  //       FirebaseStorage.instance.ref().child(image.toString());
  //   UploadTask uploadTask = reference.putFile(imagePath);

  //   uploadTask.whenComplete(() async {
  //     url = await reference.getDownloadURL();
  //     print(url);
  //   }).catchError((onError) {
  //     print(onError);
  //   });

  //   print(url);
  // }

  CollectionReference ref = FirebaseFirestore.instance.collection('waste');

  @override
  Widget build(BuildContext context) {
    return loading == false ? crclProgInd() : list();
  }

  Widget list() {
    return Scaffold(
      appBar: AppBar(title: Text('Waste')),
      floatingActionButton: camera(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            return !snapshot.hasData
                ? const Text('Loading...')
                : ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot post = snapshot.data.docs[index];
                      return ListTile(
                        leading: Text(post['quantity'].toString()),
                        title: Text('Placeholder'),
                      );
                    });
          }),
    );
  }

  crclProgInd() {
    return Center(child: CircularProgressIndicator());
  }

  Widget camera() {
    return FloatingActionButton(
      child: Icon(Icons.camera_alt),
      onPressed: () => {},
    );
  }

  pickImgGallery() {
    //pickImage(ImageSource.gallery);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => Gallery()));
  }
  //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Camera()))
}
