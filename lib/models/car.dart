class Car {
  final int? id;
  final String plaque;
  final String marque;
  final String modele;
  final String etat;
  final String clientId;
  final bool isSynced;
  final String lastModified;

  Car({
    this.id,
    required this.plaque,
    required this.marque,
    required this.modele,
    required this.etat,
    required this.clientId,
    this.isSynced = false,
    required this.lastModified,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plaque': plaque,
      'marque': marque,
      'modele': modele,
      'etat': etat,
      'clientId': clientId,
      'isSynced': isSynced ? 1 : 0,
      'lastModified': lastModified,
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
      isSynced: map['isSynced'] == 1,
      lastModified: map['lastModified'],
    );
  }
}
