import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
//import 'package:cross_file/src/types/interface.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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
  //var url;
  var quantity;
  late File imgFile;
  Future uploadImage() async {
    String fileName = basename(widget.imageFile.path);
    Reference reference =
        FirebaseStorage.instance.ref().child('files/$fileName');
    await reference.putFile(widget.imageFile);
    //UploadTask uploadTask = reference.putFile(imagePath);
    //uploadTask.whenComplete(() async => url = await reference.getDownloadURL());
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
    //imgPkr = File(widget.imagePicker!.path);
    imgFile = File(this.widget.imageFile.path); //creates File obj
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
            imgFile.toString().isEmpty == true
                ? CircularProgressIndicator(color: Colors.blueAccent.shade100)
                : Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(widget.imageFile,
                        height: height, fit: BoxFit.cover)),
            form()
          ],
        ),
      ),
      bottomNavigationBar: uploadButton(),
    );
  }

  uploadButton() {
    return InkWell(
        child: Container(
            height: 50,
            color: Colors.blueAccent.shade100,
            child: Icon(Icons.cloud_upload, size: 50)),
        splashColor: Colors.blueAccent,
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            await uploadImage();
          }
        });
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
            //decoration: InputDecoration(contentPadding: EdgeInsets.all(5)),
            maxLength: 10,
            onChanged: (value) {
              // quantity = value;
              setState(() {
                quantity = value;
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


//var imgPkrTmp = imgPkr;  //File imagePath = File(_imgFile.path); //creates file path