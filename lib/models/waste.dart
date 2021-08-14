class Waste {
  int? quantity;
  String? imageUrl;
  DateTime? date;
  dynamic id;

  Waste([
    this.quantity,
    this.imageUrl,
    this.date,
    this.id,
  ]);

  Waste.fromMap(Map<String, dynamic> data) {
    quantity = int.parse(data['quantity']);
    imageUrl = data['imageUrl'];
    date = data['date'];
    id = data['id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'date': date,
    };
  }

  String dateTime() {
    DateTime now = DateTime.now();
    return "${now.day.toString()}, ${now.month.toString()}, ${now.year.toString()}";
  }
}
