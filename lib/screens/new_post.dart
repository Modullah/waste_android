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

  @override
  void initState() {
    super.initState();
    imgFile = File(this.widget.imageFile.path);
    currWaste = Waste();
  }

  late File imgFile;
  late bool srvcOn;
  late PermissionStatus prmsGrnt;
  late Waste currWaste = Waste();

  dynamic id;
  LocationData? locationData;

  var uuid = Uuid().v4();
  var quantity, imageUrl, latitude, longitude, date;
  var locationService = Location();

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

  void retrieveLocation() async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
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
    final ref = FirebaseFirestore.instance.collection('waste').doc();

    await ref.set({
      'docID': "$ref.id",
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

                // latitude and long both return a double
                currWaste.latitude = locationData?.latitude;
                currWaste.longitude = locationData?.longitude;

                // string
                currWaste.imageUrl = imageUrl;
                // timestamp
                currWaste.date = Timestamp.now();
                // dynamic
                currWaste.id = id;
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



// latitude returns a double
// void rtrvLctn() async {
//   // locationService
//   var lcSrvc = Location();

//   // boolean
//   var srvcOn = await lcSrvc.serviceEnabled();
//   !srvcOn ? srvcOn = await lcSrvc.requestService() : srvcOn = false;

//   // if permission granted
//   var prmsGrnt = await lcSrvc.hasPermission();

//   // if permission denied then request permission. If
//   // permission denied is still true cont w/ status denied
//   prmsGrnt == PermissionStatus.denied
//       ? prmsGrnt = await lcSrvc.requestPermission()
//       : prmsGrnt = PermissionStatus.denied;

//   locationData = await lcSrvc.getLocation();
//   setState(() {});
// }

// await reference.putFile(widget.imageFile);
// uploadTask.whenComplete(() async => url = await reference.getDownloadURL());
// await uploadBytes(quantity);

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