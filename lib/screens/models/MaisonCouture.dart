import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coutureapp/screens/models/commande_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MaisonCouture {
  final String nom;
  final String localisation;
  final String description;
  final String image;
  final String id_couturuer;

  MaisonCouture({
    required this.nom,
    required this.localisation,
    required this.description,
    required this.image,
    required this.id_couturuer,
  });

  factory MaisonCouture.fromMap(Map<String, dynamic> map) {
    return MaisonCouture(
        nom: map['nom'],
        localisation: map['localisation'],
        description: map['description'],
        image: map['image'],
        id_couturuer: map['id_couturuer']);
  }

  Future<void> addCommande(
      String description, String modeleId, BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    if (description != '') {
      CommandeModel commande = CommandeModel(
        id: 'o',
        clientId: _auth.currentUser!.uid,
        description: description,
        status: 'En attente',
        dateCreation: DateTime.now().toString(),
        dateCompletion: '',
        datePlanifiee: '',
        dateLivraison: '',
        modeleId: modeleId,
      );

      CollectionReference commandeModelFirebase =
          FirebaseFirestore.instance.collection('commandemodel');

      return commandeModelFirebase.add({
        'id': commande.id,
        'clientId': commande.clientId,
        'description': commande.description,
        'status': commande.status,
        'dateCreation': commande.dateCreation,
        'dateCompletion': commande.dateCompletion,
        'datePlanifiee': commande.datePlanifiee,
        'dateLivraison': commande.dateLivraison,
        'modeleId': commande.modeleId,
      }).then((value) {
        print("User Added");
        final snackBar = SnackBar(
          content: Text('Modèle ajouté avec succès !'),
          duration: Duration(seconds: 2), // Durée d'affichage du Snackbar
        );

        // Utiliser ScaffoldMessenger pour afficher le Snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError((error) => print("Failed to add user: $error"));
    }
  }

  Future<void> addModel(String nomModel, String description, File imageFile,
      BuildContext context) async {
    if (description != '' && nomModel != '') {
      print("J'entre quand meme");
      try {
        // Étape 1 : Télécharger l'image dans Firebase Storage
        String imageFileName = imageFile.path.split('/').last;
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('model_images/$imageFileName');

        UploadTask uploadTask = storageRef.putFile(imageFile);

        // Attendre la fin du téléchargement
        final TaskSnapshot downloadUrl = await uploadTask;
        final String imageUrl = await downloadUrl.ref.getDownloadURL();

        // Étape 2 : Ajouter les informations du modèle dans Firestore
        CollectionReference modelMaisonCoutureCollection =
            FirebaseFirestore.instance.collection('modelmaison');

        await modelMaisonCoutureCollection.add({
          'nom': nomModel,
          'image': imageUrl, // URL de l'image téléchargée
          'description': description,
          'maisonCouture': nom, // Ajouter la maison de couture si nécessaire
        });

        print("Modèle ajouté avec succès !");

        final snackBar = SnackBar(
          content: Text('Modèle ajouté avec succès !'),
          duration: Duration(seconds: 2), // Durée d'affichage du Snackbar
        );

        // Utiliser ScaffoldMessenger pour afficher le Snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pushReplacementNamed(context, '/dashboard');
      } catch (error) {
        print("Erreur lors de l'ajout du modèle: $error");
      }
    }
  }
}

class ModeleMaisonCouture {
  final String id;
  final String nom;
  final String image;
  final String description;
  final String maisonCouture;

  ModeleMaisonCouture({
    required this.id,
    required this.nom,
    required this.image,
    required this.description,
    required this.maisonCouture,
  });

  factory ModeleMaisonCouture.fromMap(Map<String, dynamic> map) {
    return ModeleMaisonCouture(
        id: map['id'],
        nom: map['nom'],
        image: map['image'],
        description: map['description'],
        maisonCouture: map['maisonCouture']);
  }
}
