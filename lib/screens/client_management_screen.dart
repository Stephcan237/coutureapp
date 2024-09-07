import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coutureapp/services/gest_clients.dart';
import 'package:coutureapp/screens/models/client_model.dart';
import 'package:coutureapp/screens/models/commande_model.dart';
import 'package:coutureapp/screens/screens/client_detail_screen.dart';

class ClientManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final clientService = Provider.of<ClientService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Clients'),
        backgroundColor: Color(0xFF3E4A89),
      ),
      body: StreamBuilder<List<ClientModel>>(
        stream: clientService.getClients(), // Assurez-vous que cette méthode est définie dans ClientService
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun client trouvé.'));
          }

          final clients = snapshot.data!;

          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 4,
                child: ListTile(
                  title: Text(client.nom, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Adresse: ${client.adresse.isNotEmpty ? client.adresse : 'Non spécifiée'}'), // Vérifie si l'adresse est vide
                      Text('Téléphone: ${client.numeroTelephone != 0 ? client.numeroTelephone.toString() : 'Non spécifié'}'), // Vérifie si le numéro de téléphone est 0
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await clientService.supprimerClient(client.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Client supprimé avec succès')),
                      );
                    },
                  ),
                  onTap: () async {
                    List<CommandeModel> commandes = await clientService.getClientCommandes(client.commandeIds);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientDetailScreen(client: client, commandes: commandes),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}