import 'package:flutter/material.dart';
import 'package:coutureapp/screens/models/commande_model.dart';
import 'package:coutureapp/screens/models/cloth_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewOrderScreen extends StatelessWidget {
  final CommandeModel? commande; // Paramètre optionnel pour modifier une commande
  final ClothModel? cloth; // Modèle de vêtement sélectionné
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  final TextEditingController measurementsController = TextEditingController();
  final TextEditingController frontPhotoUrlController = TextEditingController();
  final TextEditingController sidePhotoUrlController = TextEditingController();

  NewOrderScreen({this.commande, this.cloth}) {
    if (commande != null) {
      descriptionController.text = commande!.description;
      priorityController.text = commande!.status;
      measurementsController.text = commande!.measurements;
      frontPhotoUrlController.text = commande!.frontPhotoUrl;
      sidePhotoUrlController.text = commande!.sidePhotoUrl;
    }
    if (cloth != null) {
      descriptionController.text = 'Commande pour ${cloth!.name}';
      frontPhotoUrlController.text = cloth!.imageUrl; // Assurez-vous que cette propriété est définie dans ClothModel
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(commande != null ? 'Modifier la Commande' : 'Nouvelle Commande'),
        backgroundColor: Color(0xFF3E4A89),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: priorityController,
                decoration: InputDecoration(labelText: 'Priorité'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: measurementsController,
                decoration: InputDecoration(labelText: 'Mesures'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: frontPhotoUrlController,
                decoration: InputDecoration(labelText: 'URL de la Photo de Face'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: sidePhotoUrlController,
                decoration: InputDecoration(labelText: 'URL de la Photo de Profil'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Générez un nouvel ID si nécessaire ou utilisez l'ID existant
                  String id = commande?.id ?? FirebaseFirestore.instance.collection('commandes').doc().id;

                  final newCommande = CommandeModel(
                    id: id,
                    clientId: 'client_id', // Remplacez par l'ID du client
                    description: descriptionController.text,
                    status: priorityController.text,
                    dateCreation: commande?.dateCreation ?? Timestamp.now(),
                    frontPhotoUrl: frontPhotoUrlController.text,
                    sidePhotoUrl: sidePhotoUrlController.text,
                    datePlanifiee: commande?.datePlanifiee,
                    dateLivraison: commande?.dateLivraison,
                    measurements: measurementsController.text,
                  );

                  if (commande != null) {
                    // Mise à jour de la commande existante
                    await FirebaseFirestore.instance
                        .collection('commandes')
                        .doc(id)
                        .update(newCommande.toMap());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Commande mise à jour avec succès')),
                    );
                  } else {
                    // Ajout d'une nouvelle commande
                    await FirebaseFirestore.instance
                        .collection('commandes')
                        .doc(id)
                        .set(newCommande.toMap());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Commande ajoutée avec succès')),
                    );
                  }

                  Navigator.pop(context, newCommande);
                },
                child: Text(commande != null ? 'Mettre à Jour' : 'Ajouter la Commande'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
