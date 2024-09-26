import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coutureapp/screens/models/MaisonCouture.dart';
import 'package:coutureapp/services/ges.dart';
import 'package:flutter/material.dart';

class Mes_modele extends StatefulWidget {
  final MaisonCouture maison;
  const Mes_modele({super.key, required this.maison});

  @override
  State<Mes_modele> createState() => _Mes_modeleState();
}

class _Mes_modeleState extends State<Mes_modele> {
  List<ModeleMaisonCouture> modelmaisoncouture = [];
  Future<QuerySnapshot<Object?>>? futureModelmaisoncouture;

  @override
  void initState() {
    super.initState();
    fetchModel();
  }

  void fetchModel() {
    setState(() {
      futureModelmaisoncouture = Couture().getModel(widget.maison.nom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes modeles"),
      ),
      body: FutureBuilder<QuerySnapshot>(
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
              return const Center(child: Text("Pas de modeles"));
            } else {
              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  ModeleMaisonCouture modelmaisoncouture = ModeleMaisonCouture(
                      id: document.id,
                      nom: data['nom'],
                      image: data['image'],
                      description: data['description'],
                      maisonCouture: data['maisonCouture']);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildMaisonCard(modelmaisoncouture),
                  );
                }).toList(),
              );
            }
          }),
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
