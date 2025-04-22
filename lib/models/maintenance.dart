class Maintenance {
  int? id;
  int carId;
  String description;
  String date;

  Maintenance({this.id, required this.carId, required this.description, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'carId': carId,
      'description': description,
      'date': date,
    };
  }

  factory Maintenance.fromMap(Map<String, dynamic> map) {
    return Maintenance(
      id: map['id'],
      carId: map['carId'],
      description: map['description'],
      date: map['date'],
    );
  }
}
