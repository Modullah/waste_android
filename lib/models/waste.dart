//import 'package:intl/intl.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class Waste {
  int? quantity;
  double? latitude, longitude;
  String? imageUrl;
  DateTime? date;

  Waste([
    this.quantity,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.date,
  ]);

  Waste.fromMap(Map<String, dynamic> data) {
    quantity = int.parse(data['quantity']);
    latitude = data['latitude'];
    longitude = data['longitude'];
    imageUrl = data['imageUrl'];
    date = data['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'date': date,
    };
  }

  // String dateTimeStr(DateTime date) {
  //   return DateFormat('EEEE, MMMM d, ' 'yyyy').format(date);
  // }
}

// Waste.fromSnapshot({required DocumentSnapshot snapshot}) {
  //   this.quantity = snapshot.json['quantity'];
  //   this.date = snapshot.json['date'].toDate();
  //   this.imageUrl = snapshot.json['imageUrl'];

  //   this.latitude = snapshot.json['latitude'];
  //   this.longitude = snapshot.json['longitude'];

  //   this.quantity = snapshot.data['quantity'];
  //   this.latitude = json['latitude'];
  //   this.longitude = json['longitude'];
  //   this.imageUrl = json['imageUrl'];
  //   this.date = snapshot.json['date'].toDate();
  // }


//  Post.fromMap(Map<String,dynamic> data) {
//     this.date = data['date'];
//     this.imageUrl = data['imageUrl'];
//     this.quantity = data['quantity'];
//     this.latitude = data['latitude'];
//     this.longitude = data['longitude'];
//   }[quantity, latitude, longitude, imageUrl, date]
// {quantity, latitude, longitude, imageUrl, date}
//  Post.fromSnapshot({DocumentSnapshot snapshot}){
//     this.date = snapshot.json['date'].toDate();
//     this.imageUrl = snapshot.json['imageUrl'];
//     this.quantity = snapshot.json['quantity'];
//     this.latitude = snapshot.json['latitude'];
//     this.longitude = snapshot.json['longitude'];
//   }