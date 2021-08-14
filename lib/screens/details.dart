import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:waste/models/waste.dart';
import 'dart:io';

class DetailsPage extends StatefulWidget {
  final AsyncSnapshot asyncSnapshot;
  final Waste currWaste;

  DetailsPage({Key? key, required this.asyncSnapshot, required this.currWaste})
      : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Waste waste;
  late File imageFile;

  Future pickImage() async {
    final imagePicker =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagePicker == null) return;
    imageFile = File(imagePicker.path);
  }

  @override
  void initState() {
    super.initState();
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
            waste.toString().isEmpty == true
                ? CircularProgressIndicator(color: Colors.blueAccent.shade100)
                : Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(imageFile,
                        height: height, fit: BoxFit.cover)),
          ],
        ),
      ),
    );
  }
}

class Layout extends StatelessWidget {
  const Layout({
    Key? key,
    required this.waste,
  }) : super(key: key);

  final Waste waste;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //Heading(waste: waste),
        //Frame(waste: waste),
        //Quantity(waste: waste),
      ],
    );
  }
}
