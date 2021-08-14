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
    retrieveLocation();
    imgFile = File(this.widget.imageFile.path);
    waste = this.widget.currWaste;
  }

  late File imgFile;
  late Waste waste;
  late bool srvcOn;
  late PermissionStatus prmsGrnt;

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
            keyboardInputForm(),
          ],
        ),
      ),
      bottomNavigationBar: uploadButton(context),
    );
  }

  captureData() {
    // latitude and long both return a double
    waste.latitude = locationData?.latitude;
    waste.longitude = locationData?.longitude;
    // string
    waste.imageUrl = imageUrl;
    // timestamp
    waste.date = Timestamp.now().toDate();
    // dynamic
    waste.id = id;
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
            await uploadWaste(waste);
            Navigator.of(context).pop();
          }
        });
  }

  uploadWaste(Waste waste) async {
    final ref = FirebaseFirestore.instance.collection('waste').doc();

    await ref.set({
      'doc_id': "$id",
      "quantity": "$quantity",
      "latitude": "$latitude",
      "longitude": "$longitude",
      "imageUrl": "$imageUrl",
      "date": "$date",
    });

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
            initialValue: (waste.quantity).toString(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value.';
              } else {
                print('Error');
              }
              return null;
            },
            onSaved: (value) => waste.quantity = int.parse(value!),
          ),
        ],
      ),
    );
  }
}


// quantity = value;
//setState(() {});
     
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