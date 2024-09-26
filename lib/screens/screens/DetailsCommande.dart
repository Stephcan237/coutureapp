import 'package:coutureapp/screens/models/commande_model.dart';
import 'package:flutter/material.dart';

class CommandeDetailsPage extends StatelessWidget {
  final CommandeModel commande;

  CommandeDetailsPage({required this.commande});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la commande'),
        backgroundColor: Color(0xFF6200EE), // Couleur violette pour la barre
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Commande numéro : ${commande.id}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Client ID', commande.clientId),
            _buildDetailRow('Description', commande.description),
            _buildDetailRow('Statut', commande.status),
            _buildDetailRow('Date de création', commande.dateCreation.toString()),
            _buildDetailRow('Date de complétion', commande.dateCompletion?.toString() ?? 'Non disponible'),
            _buildDetailRow('Date planifiée', commande.datePlanifiee?.toString() ?? 'Non disponible'),
            _buildDetailRow('Date de livraison', commande.dateLivraison?.toString() ?? 'Non disponible'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
