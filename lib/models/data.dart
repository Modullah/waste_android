// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class Data {
//   late int quantity;
//   late double latitude, longitude;
//   late String imageUrl;
//   late DateTime date;

//   Data([quantity, latitude, longitude, imageUrl, date]);

//   Data.fromMap(Map<String, dynamic> json) {
//     this.quantity = int.parse(json['quantity']);
//     this.latitude = json['latitude'];
//     this.longitude = json['longitude'];
//     this.imageUrl = json['imageUrl'];
//     this.date = json['date'];
//   }

//   String dateTimeStr(DateTime date) {
//     return DateFormat('EEEE, MMMM d, ' 'yyyy').format(date);
//   }

//   Data.fromSnapshot({required DocumentSnapshot snapshot}) {
//     // this.quantity = snapshot.json['quantity'];
//     // this.date = snapshot.json['date'].toDate();
//     // this.imageUrl = snapshot.json['imageUrl'];

//     // this.latitude = snapshot.json['latitude'];
//     // this.longitude = snapshot.json['longitude'];

//     this.quantity = snapshot.data['quantity'];
//     this.latitude = json['latitude'];
//     this.longitude = json['longitude'];
//     this.imageUrl = json['imageUrl'];
//     this.date = snapshot.json['date'].toDate();
//   }
// }


//  Post.fromMap(Map<String,dynamic> data) {
//     this.date = data['date'];
//     this.imageUrl = data['imageUrl'];
//     this.quantity = data['quantity'];
//     this.latitude = data['latitude'];
//     this.longitude = data['longitude'];
//   }
// {quantity, latitude, longitude, imageUrl, date}
//  Post.fromSnapshot({DocumentSnapshot snapshot}){
//     this.date = snapshot.json['date'].toDate();
//     this.imageUrl = snapshot.json['imageUrl'];
//     this.quantity = snapshot.json['quantity'];
//     this.latitude = snapshot.json['latitude'];
//     this.longitude = snapshot.json['longitude'];
//   }