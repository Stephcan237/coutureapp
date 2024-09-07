import 'package:cloud_firestore/cloud_firestore.dart';

class CommandeModel {
  final String id;
  final String clientId;
  final String description;
  final String status; // Exemples: "En attente", "En cours", "Terminée"
  final Timestamp dateCreation;
  final Timestamp? dateCompletion;
  final Timestamp? datePlanifiee;
  final Timestamp? dateLivraison;
  final String frontPhotoUrl;
  final String sidePhotoUrl;
  final String measurements; // Changé de Map<String, dynamic> à String

  CommandeModel({
    required this.id,
    required this.clientId,
    required this.description,
    required this.status,
    required this.dateCreation,
    this.dateCompletion,
    this.datePlanifiee,
    this.dateLivraison,
    required this.frontPhotoUrl,
    required this.sidePhotoUrl,
    required this.measurements,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'description': description,
      'status': status,
      'dateCreation': dateCreation,
      'dateCompletion': dateCompletion,
      'datePlanifiee': datePlanifiee,
      'dateLivraison': dateLivraison,
      'frontPhotoUrl': frontPhotoUrl,
      'sidePhotoUrl': sidePhotoUrl,
      'measurements': measurements, // Maintenant une chaîne de caractères
    };
  }

  factory CommandeModel.fromMap(Map<String, dynamic> map) {
    return CommandeModel(
      id: map['id'] ?? 'commandeid', // Utilisez une valeur par défaut si null
      clientId: map['clientId'] ?? 'clientid', // Utilisez une valeur par défaut si null
      description: map['description'] ?? 'papaa', // Utilisez une valeur par défaut si null
      status: map['status'] ?? 'accepté', // Utilisez une valeur par défaut si null
      dateCreation: map['dateCreation'] as Timestamp? ?? Timestamp.now(), // Utilisez une valeur par défaut si null
      dateCompletion: map['dateCompletion'] != null
          ? map['dateCompletion'] as Timestamp
          : null,
      datePlanifiee: map['datePlanifiee'] != null
          ? map['datePlanifiee'] as Timestamp
          : null,
      dateLivraison: map['dateLivraison'] != null
          ? map['dateLivraison'] as Timestamp
          : null,
      frontPhotoUrl: map['frontPhotoUrl'] ?? 'photo1', // Utilisez une valeur par défaut si null
      sidePhotoUrl: map['sidePhotoUrl'] ?? 'photo2', // Utilisez une valeur par défaut si null
      measurements: map['measurements'] as String? ?? '70-10-10', // Utilisez une valeur par défaut si null
    );
  }

  DateTime? get dateCompletionAsDateTime => dateCompletion?.toDate();
  DateTime? get datePlanifieeAsDateTime => datePlanifiee?.toDate();
  DateTime? get dateLivraisonAsDateTime => dateLivraison?.toDate();
}