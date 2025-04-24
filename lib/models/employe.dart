enum Role {
  secretaire,
  commercial,
  mecanicien,
  peintre,
  carrossier,
}

class Employe {
  final String id;
  final String nom;
  final String prenom;
  final Role role;
  final bool isSynced;
  final String lastModified;

  Employe({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.role,
    this.isSynced = false,
    required this.lastModified,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'role': role.name,
      'isSynced': isSynced ? 1 : 0,
      'lastModified': lastModified,
    };
  }

  factory Employe.fromMap(Map<String, dynamic> map) {
    return Employe(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      role: Role.values.firstWhere((r) => r.name == map['role']),
      isSynced: map['isSynced'] == 1,
      lastModified: map['lastModified'],
    );
  }
}
