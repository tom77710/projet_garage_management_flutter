
class Client {
  final String id;
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String? adresse;

  Client({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    this.adresse,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
      'adresse': adresse,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      telephone: map['telephone'],
      email: map['email'],
      adresse: map['adresse'],
    );
  }
}
