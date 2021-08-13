//import 'dart:convert';
import 'dart:io';
//import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:path_provider/path_provider.dart';

class NewPost extends StatefulWidget {
  final File? image;
  const NewPost({Key? key, this.image}) : super(key: key);
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //var url;
  var quantity;
  var imageFileObj;
  Future uploadImage() async {
    //final imagePath = File(widget.image!.path);
    Reference reference =
        FirebaseStorage.instance.ref().child(imageFileObj.toString());
    reference.putFile(imageFileObj);
    //await uploadBytes(quantity);
    //UploadTask uploadTask = reference.putFile(imagePath);
    //uploadTask.whenComplete(() async => url = await reference.getDownloadURL());
  }

  // uploadBytes(String val) async {
  //   var valStrPath = await _createFileFromString(val);
  //   final valFileObj = File(valStrPath);
  //   Reference reference =
  //       FirebaseStorage.instance.ref().child(valFileObj.toString());
  //   reference.putFile(valFileObj);
  // }

  // Future<String> _createFileFromString(String val) async {
  //   final encodedStr = quantity;
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
    imageFileObj = widget.image;
  }

  // Widget Img() {
  //   return Image.file(imagePath);
  // }

  @override
  Widget build(BuildContext context) {
    double height = (MediaQuery.of(context).size.height) * .35;
    return Scaffold(
      appBar: AppBar(title: Text('New Post')),
      body: Container(
        //width: (MediaQuery.of(context).size.width),
        alignment: Alignment.topCenter,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //const SizedBox(height: 20),
            imageFileObj == null
                ? CircularProgressIndicator(color: Colors.blueAccent.shade100)
                : Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(imageFileObj,
                        height: height, fit: BoxFit.cover)),
            //form()
          ],
        ),
      ),
      bottomNavigationBar: uploadButton(context),
    );
  }

  Widget uploadButton(context) {
    return InkWell(
        child: Container(
            height: 50,
            color: Colors.blueAccent.shade100,
            child: Icon(Icons.cloud_upload, size: 50)),
        onTap: () {
          //if (_formKey.currentState!.validate()) {
          uploadImage();
          //}
        });
  }

  // Widget form() {
  //   return Form(
  //     key: _formKey,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         TextFormField(
  //           decoration: const InputDecoration(
  //             hintText: 'Number of Wasted Items',
  //           ),
  //           keyboardType: TextInputType.number,
  //           textAlign: TextAlign.center,
  //           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //           //decoration: InputDecoration(contentPadding: EdgeInsets.all(5)),
  //           maxLength: 10,
  //           onChanged: (value) {
  //             quantity = value;
  //           },
  //           validator: (var value) {
  //             if (value == null || value.isEmpty) {
  //               return 'Please enter a value.';
  //             } else {
  //               print('Error');
  //             }
  //             return null;
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
