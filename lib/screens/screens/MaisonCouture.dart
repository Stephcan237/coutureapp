import 'package:coutureapp/screens/screens/passerCommande.dart';
import 'package:flutter/material.dart';

import '../models/MaisonCouture.dart';

class MaisonCouturePage extends StatelessWidget {
  final MaisonCouture maisonCouture;

  // Le constructeur prend un objet MaisonCouture
  MaisonCouturePage({required this.maisonCouture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(maisonCouture.nom), // Affiche le nom de la maison de couture
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Action pour les notifications
              print("Notifications clicked");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            // Affichage de l'image de la maison de couture
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: maisonCouture.image.isNotEmpty
                    ? Image.network(maisonCouture.image, fit: BoxFit.cover)
                    : Center(
                        child: Icon(
                          Icons.image,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 16),
            // Détails de la maison de couture
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maisonCouture.nom,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6200EE),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    maisonCouture.localisation,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    maisonCouture.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            // Bouton pour passer une commande
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SaisieCommandePage(maisonCouture: maisonCouture),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Center(
                  child: Text(
                    'Passer une commande',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  passerCommande({required MaisonCouture maisonCouture}) {}
}
