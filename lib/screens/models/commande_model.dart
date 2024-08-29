class CommandeModel {
  final String id;
  final String clientId;
  final String description;
  final String status; // Exemples: "En attente", "En cours", "Terminée"
  final DateTime dateCreation;
  final DateTime? dateCompletion;
  final DateTime? datePlanifiee; // Nouvelle date de planification
  final DateTime? dateLivraison; // Nouvelle date de livraison

  CommandeModel({
    required this.id,
    required this.clientId,
    required this.description,
    required this.status,
    required this.dateCreation,
    this.dateCompletion,
    this.datePlanifiee,
    this.dateLivraison,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'description': description,
      'status': status,
      'dateCreation': dateCreation.toIso8601String(),
      'dateCompletion': dateCompletion?.toIso8601String(),
      'datePlanifiee': datePlanifiee?.toIso8601String(),
      'dateLivraison': dateLivraison?.toIso8601String(),
    };
  }

  factory CommandeModel.fromMap(Map<String, dynamic> map) {
    return CommandeModel(
      id: map['id'],
      clientId: map['clientId'],
      description: map['description'],
      status: map['status'],
      dateCreation: DateTime.parse(map['dateCreation']),
      dateCompletion: map['dateCompletion'] != null
          ? DateTime.parse(map['dateCompletion'])
          : null,
      datePlanifiee: map['datePlanifiee'] != null
          ? DateTime.parse(map['datePlanifiee'])
          : null,
      dateLivraison: map['dateLivraison'] != null
          ? DateTime.parse(map['dateLivraison'])
          : null,
    );
  }
}
