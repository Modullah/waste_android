import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:waste/models/waste.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class NewPost extends StatefulWidget {
  final File imageFile;
  const NewPost({
    Key? key,
    required this.imageFile,
  }) : super(key: key);
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //FirebaseFirestore firestore = FirebaseFirestore.instance;
  late LocationData lctnData;
  var quantity, imageUrl, latitude, longitude, date;
  var uuid = Uuid().v4();
  late File imgFile;
  late bool srvcOn;
  late PermissionStatus prmsGrnt;
  late Waste currWaste = Waste();

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
    // await reference.putFile(widget.imageFile);
    // uploadTask.whenComplete(() async => url = await reference.getDownloadURL());
    //await uploadBytes(quantity);
  }

  // uploadBytes(String val) async {
  //   var valStrPath = await _createFileFromString(val);
  //   String valName = basename(valStrPath);
  //   final valFileObj = File(valStrPath);
  //   Reference reference =
  //       FirebaseStorage.instance.ref().child('files/$valName');
  //   await reference.putFile(valFileObj);
  // }

  // Future<String> _createFileFromString(String val) async {
  //   final encodedStr = val;
  //   Uint8List bytes = base64.decode(encodedStr);
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   File file = File(
  //       "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
  //   await file.writeAsBytes(bytes);
  //   return file.path;
  // }

  @override
  void initState() {
    super.initState();
    imgFile = File(this.widget.imageFile.path); //creates File obj
    rtrvLctn(); //retrieveLocation
    currWaste = Waste();
  }

  void rtrvLctn() async {
    var lcSrvc = Location(); //lcSrvc is locationService
    srvcOn = await lcSrvc.serviceEnabled(); //type boolean
    !srvcOn ? srvcOn = await lcSrvc.requestService() : srvcOn = false;

    prmsGrnt = await lcSrvc.hasPermission(); //type PermissionStatus, if granted

    prmsGrnt == PermissionStatus.denied
        ? prmsGrnt = await lcSrvc.requestPermission()
        : prmsGrnt = PermissionStatus.denied;

    lctnData = await lcSrvc.getLocation();
    setState(() {});
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
            form(),
          ],
        ),
      ),
      bottomNavigationBar: uploadButton(context),
    );
  }

  uploadButton(context) {
    return InkWell(
        child: Container(
            height: 50,
            color: Colors.blueAccent.shade100,
            child: Icon(Icons.cloud_upload, size: 50)),
        splashColor: Colors.blueAccent,
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await uploadImage();
            await uploadWaste(currWaste);
            Navigator.of(context).pop();
          }
        });
  }

  uploadWaste(Waste currWaste) async {
    // CollectionReference wasteRef =
    //     FirebaseFirestore.instance.collection('waste');
    // FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
    // CollectionReference reference =
    //     FirebaseFirestore.instance.collection('waste');

    //await ({"Title": "$title", "Author": "$author"});
    // });
    final DocumentReference documentReference = 
   var collection = FirebaseFirestore.instance.collection('waste');
collection 
    .doc('some_id') // <-- Doc ID where data should be updated.
    .update({'key' : 'value'}) // <-- Updated data
    .then((_) => print('Updated'))
    .catchError((error) => print('Update failed: $error'));

    await reference.add({
      "quantity": "$quantity",
      "latitude": "$latitude",
      "longitude": "$longitude",
      "imageUrl": "$imageUrl",
      "date": "$date",
    });
    // await reference.add({
    //   "quantity": currWaste.quantity,
    //   "latitude": currWaste.latitude,
    //   "longitude": currWaste.longitude,
    //   "imageUrl": currWaste.imageUrl,
    //   "date": currWaste.date,
    // });
  }

  Widget form() {
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
            onChanged: (value) {
              // quantity = value;
              setState(() {
                currWaste.quantity = int.parse(value);
                currWaste.latitude =
                    lctnData.latitude; //latitude returns a double
                currWaste.longitude =
                    lctnData.longitude; //longitude returns a double
                currWaste.imageUrl = imageUrl;
                currWaste.date = Timestamp.now();
              });
            },
            validator: (var value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value.';
              } else {
                print('Error');
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
