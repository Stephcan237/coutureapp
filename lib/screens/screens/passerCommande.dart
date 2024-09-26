import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coutureapp/screens/models/MaisonCouture.dart';
import 'package:coutureapp/services/ges.dart';
import 'package:flutter/material.dart';

class SaisieCommandePage extends StatefulWidget {
  final MaisonCouture maisonCouture;

  SaisieCommandePage({required this.maisonCouture});

  @override
  _SaisieCommandePageState createState() => _SaisieCommandePageState();
}

class _SaisieCommandePageState extends State<SaisieCommandePage> {
  late ModeleMaisonCouture _selectedModele;
  List<ModeleMaisonCouture> modelmaisoncouture = [];
  Future<QuerySnapshot<Object?>>? futureModelmaisoncouture;
  final TextEditingController _descriptionControleur = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchModel();
  }

  void fetchModel() {
    setState(() {
      futureModelmaisoncouture = Couture().getModel(widget.maisonCouture.nom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saisie de Commande'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choisissez un modèle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            FutureBuilder<QuerySnapshot>(
                future: futureModelmaisoncouture,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.purple,
                    ));
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Vous n'etes pas connecté "),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child:
                            Text("Cette maison de couture n'a pas de modèles"));
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        ModeleMaisonCouture modelmaisoncouture =
                            ModeleMaisonCouture(
                                id: document.id,
                                nom: data['nom'],
                                image: data['image'],
                                description: data['description'],
                                maisonCouture: data['maisonCouture']);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            Text("Validation de la commande"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                                "Ajoute une description pour votre commande"),
                                            TextField(
                                              controller:
                                                  _descriptionControleur,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Votre descriptioin',
                                              ),
                                              maxLines: 3,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                widget.maisonCouture
                                                    .addCommande(
                                                        _descriptionControleur
                                                            .text,
                                                        modelmaisoncouture.id,
                                                        context);
                                                Navigator.pop(context);
                                              },
                                              child: const Text("valider")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("retour")),
                                        ],
                                      );
                                    });
                              },
                              child: _buildMaisonCard(modelmaisoncouture)),
                        );
                      }).toList(),
                    );
                  }
                }),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMaisonCard(ModeleMaisonCouture maison) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image de la maison de couture
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              maison.image,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          // Détails de la maison de couture
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maison.nom,
                  style: TextStyle(
                    color: Color(0xFF6200EE), // Texte en violet
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  maison.maisonCouture,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  maison.description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Bouton pour voir les détails
        ],
      ),
    );
  }
}
