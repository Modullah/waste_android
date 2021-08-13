import 'package:intl/intl.dart';

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

  String dateTimeStr(DateTime date) {
    return DateFormat('EEEE, MMMM d, ' 'yyyy').format(date);
  }
}
