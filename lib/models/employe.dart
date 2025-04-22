class Employe {
  final String id;
  final String nom;
  final String prenom;
  final Role role;

  Employe({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'role': role.name,
    };
  }

  factory Employe.fromMap(Map<String, dynamic> map) {
    return Employe(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      role: Role.values.firstWhere((r) => r.name == map['role']),
    );
  }
}

enum Role {
  secretaire,
  commercial,
  mecanicien,
  peintre,
  carrossier,
}
