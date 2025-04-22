class Car {
  final int? id;
  final String plaque;
  final String marque;
  final String modele;
  final String etat;
  final String clientId; // IMPORTANT

  Car({
    this.id,
    required this.plaque,
    required this.marque,
    required this.modele,
    required this.etat,
    required this.clientId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plaque': plaque,
      'marque': marque,
      'modele': modele,
      'etat': etat,
      'clientId': clientId,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      plaque: map['plaque'],
      marque: map['marque'],
      modele: map['modele'],
      etat: map['etat'],
      clientId: map['clientId'],
    );
  }
}