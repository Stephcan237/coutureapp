import 'package:flutter/material.dart';
import 'package:coutureapp/screens/models/commande_model.dart';
import 'package:coutureapp/services/gest_commandes.dart';
import 'package:provider/provider.dart';
import 'package:coutureapp/screens/screens/new_order_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  final CommandeModel commande;

  OrderDetailScreen({required this.commande});

  @override
  Widget build(BuildContext context) {
    final commandeService = Provider.of<CommandeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Commande'),
        backgroundColor: Color(0xFF3E4A89),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${commande.description}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Statut: ${commande.status}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Date de Création: ${commande.dateCreation.toDate()}', style: TextStyle(fontSize: 18)),
            if (commande.datePlanifiee != null)
              Text('Date Planifiée: ${commande.datePlanifiee?.toDate()}', style: TextStyle(fontSize: 18)),
            if (commande.dateLivraison != null)
              Text('Date de Livraison: ${commande.dateLivraison?.toDate()}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewOrderScreen(commande: commande, cloth: null),
                  ),
                );
              },
              child: Text('Modifier la Commande'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await commandeService.supprimerCommande(commande.id, commande.clientId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Commande supprimée avec succès')),
                );
                Navigator.pop(context); // Retourner à l'écran précédent
              },
              child: Text('Supprimer la Commande'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}