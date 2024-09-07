import 'package:flutter/material.dart';
import 'package:coutureapp/screens/models/commande_model.dart';
import 'package:coutureapp/screens/models/client_model.dart';

class ClientDetailScreen extends StatelessWidget {
  final ClientModel client;
  final List<CommandeModel> commandes;

  ClientDetailScreen({required this.client, required this.commandes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Client'),
        backgroundColor: Color(0xFF3E4A89),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nom: ${client.nom}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Adresse: ${client.adresse}', style: TextStyle(fontSize: 18)), // Assurez-vous que 'adresse' est une propriété de ClientModel
            SizedBox(height: 8),
            Text('Numéro de Téléphone: ${client.numeroTelephone}', style: TextStyle(fontSize: 18)), // Assurez-vous que 'numeroTelephone' est une propriété de ClientModel
            SizedBox(height: 20),
            Text('Commandes:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: commandes.length,
                itemBuilder: (context, index) {
                  final commande = commandes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(commande.description),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Statut: ${commande.status}'),
                          if (commande.datePlanifiee != null)
                            Text('Date Planifiée: ${commande.datePlanifiee?.toDate()}'),
                          if (commande.dateLivraison != null)
                            Text('Date de Livraison: ${commande.dateLivraison?.toDate()}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}