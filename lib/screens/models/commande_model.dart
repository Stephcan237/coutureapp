import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommandeModel {
  final String id;
  final String clientId;
  final String description;
  final String status;
  final String dateCreation;
  final String? dateCompletion;
  final String? datePlanifiee;
  final String? dateLivraison;
  final String modeleId; // ID du modèle sélectionné

  CommandeModel({
    required this.id,
    required this.clientId,
    required this.description,
    required this.status,
    required this.dateCreation,
    this.dateCompletion,
    this.datePlanifiee,
    this.dateLivraison,
    required this.modeleId,
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
      'modeleId': modeleId,
    };
  }

  factory CommandeModel.fromMap(Map<String, dynamic> map) {
    return CommandeModel(
      id: map['id'],
      clientId: map['clientId'],
      description: map['description'],
      status: map['status'],
      dateCreation: map['dateCreation'],
      dateCompletion: map['dateCompletion'],
      datePlanifiee: map['datePlanifiee'],
      dateLivraison: map['dateLivraison'],
      modeleId: map['modeleId'],
    );
  }
}
