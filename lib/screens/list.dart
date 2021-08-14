import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waste/models/waste.dart';
import 'package:waste/screens/new_post.dart';
import 'dart:io';

class List extends StatefulWidget {
  final Waste currWaste;
  const List({
    Key? key,
    required this.currWaste,
  }) : super(key: key);
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
  //download data from db
  CollectionReference ref = FirebaseFirestore.instance.collection('waste');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waste'),
        centerTitle: true,
      ),
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
                      DocumentSnapshot waste = snapshot.data.docs[index];
                      return ListTile(
                        leading: Text(waste['quantity'].toString()),
                        title: Text('Placeholder'),
                      );
                    });
          }),
    );
  }

  Widget camera() {
    return FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () => pickImage(ImageSource.gallery));
  }

  Future pickImage(ImageSource source) async {
    final imagePicker = await ImagePicker().pickImage(source: source);
    if (imagePicker == null) return;
    final imageFile = File(imagePicker.path);
    navNewPost(imageFile);
  }

  void navNewPost(File imageFile) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NewPost(imageFile: imageFile, currWaste: widget.currWaste)));
  }
}

//[pickImage(ImageSource.gallery)]
// crclProgInd() {
//   return Center(child: CircularProgressIndicator());
// }


  //pickImgGallery() {
    //pickImage(ImageSource.gallery);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => Gallery()));
  //}
  //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Camera()))