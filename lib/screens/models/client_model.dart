// import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  final String id;
  final String nom;
  final String email;
  final int numeroTelephone; // Assurez-vous que c'est un int
  final String adresse;
  final String priorite; // Exemples: "Client classique", "Client VIP", "Client saisonnier"
  final Map<String, dynamic> measurements; // Assurez-vous que cela est un Map
  final List<String> commandeIds;

  ClientModel({
    required this.id,
    required this.nom,
    required this.email,
    required this.priorite,
    required this.measurements,
    required this.commandeIds,
    required this.adresse,
    required this.numeroTelephone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'priorite': priorite,
      'measurements': measurements,
      'commandeIds': commandeIds,
      'adresse': adresse,
      'numeroTelephone': numeroTelephone,
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] ?? 'clientid', // Utilisez une valeur par défaut si null
      nom: map['nom'] ?? 'yanzeu', // Utilisez une valeur par défaut si null
      email: map['email'] ?? 'yanzsteph@gmail.com', // Utilisez une valeur par défaut si null
      adresse: map['adresse'] ?? 'yaoundé', // Utilisez une valeur par défaut si null
      numeroTelephone: map['numeroTelephone'] != null 
          ? map['numeroTelephone'] as int 
          : 682667917, // Utilisez une valeur par défaut si null
      priorite: map['priorite'] ?? 'moyenne', // Utilisez une valeur par défaut si null
      measurements: (map['measurements'] is Map<String, dynamic>) 
          ? map['measurements'] 
          : {}, // Utilisez un Map vide si null ou non valide
      commandeIds: List<String>.from(map['commandeIds'] ?? ['commande1']), // Utilisez une valeur par défaut si null
    );
  }
}