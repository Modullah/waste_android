import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:waste/models/waste.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class NewPost extends StatefulWidget {
  final File imageFile;
  final Waste currWaste;
  const NewPost({
    Key? key,
    required this.imageFile,
    required this.currWaste,
  }) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    imgFile = File(this.widget.imageFile.path);
  }

  dynamic id;
  late File imgFile;

  var uuid = Uuid().v4();
  var quantity, imageUrl, date;

  Future uploadImage() async {
    String fileName = basename(widget.imageFile.path);
    await FirebaseStorage.instance
        .ref()
        .child('files/$uuid/$fileName')
        .putFile(widget.imageFile);

    imageUrl = await FirebaseStorage.instance
        .ref()
        .child('files/$fileName')
        .getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    double height = (MediaQuery.of(context).size.height) * .35;
    return Scaffold(
      appBar: AppBar(title: Text('New Post')),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            imgFile.toString().isEmpty == true
                ? CircularProgressIndicator(color: Colors.blueAccent.shade100)
                : Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(widget.imageFile,
                        height: height, fit: BoxFit.cover)),
            keyboardInputForm(),
          ],
        ),
      ),
      bottomNavigationBar: uploadButton(context),
    );
  }

  captureData() {
    // string
    widget.currWaste.imageUrl = imageUrl;
    // timestamp
    widget.currWaste.date = Timestamp.now().toDate();
    // dynamic
    widget.currWaste.id = id;
  }

  uploadButton(context) {
    return InkWell(
        child: Container(
          height: 50,
          color: Colors.blueAccent.shade100,
          child: Ink(
            child: Icon(
              Icons.cloud_upload,
              size: 50,
            ),
            color: Colors.purpleAccent.shade100,
          ),
        ),
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await uploadImage();
            await captureData();
            await uploadWaste(widget.currWaste);
            Navigator.of(context).pop();
          }
        });
  }

  uploadWaste(Waste currWaste) async {
    if (currWaste != widget.currWaste) return;
    final ref = FirebaseFirestore.instance.collection('waste').doc();

    await ref.set({
      'doc_id': "$id",
      "quantity": "$quantity",
      "imageUrl": "$imageUrl",
      "date": "$date",
    });
  }

  Widget keyboardInputForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Number of Wasted Items',
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 10,
          ),
        ],
      ),
    );
  }
}



  //initialValue: (waste.quantity).toString(),
  // validator: (value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter a value.';
  //   } else {
  //     print('Error');
  //   }
  //   return null;
  // },
  //onSaved: (value) => waste.quantity = int.parse(value!),

  // CollectionReference wasteRef =
  //     FirebaseFirestore.instance.collection('waste');
  // FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
  // CollectionReference reference =
  //     FirebaseFirestore.instance.collection('waste');

  //await ({"Title": "$title", "Author": "$author"});
  // });
  // final ref = FirebaseFirestore.instance.collection('waste').doc();
  //var ref = FirebaseFirestore.instance.collection('waste').doc();
  // await reference.add({
  //   "quantity": waste.quantity,
  //   "latitude": waste.latitude,
  //   "longitude": waste.longitude,
  //   "imageUrl": waste.imageUrl,
  //   "date": waste.date,
  // });