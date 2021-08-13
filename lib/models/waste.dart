import 'package:cloud_firestore/cloud_firestore.dart';

class Waste {
  int? quantity;
  double? latitude, longitude;
  String? imageUrl;
  Timestamp? date;

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

  String dateTime() {
    DateTime now = DateTime.now();
    return "${now.day.toString()}, ${now.month.toString()}, ${now.year.toString()}";
  }
}
