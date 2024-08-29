import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coutureapp/services/gest_clients.dart';
import 'package:coutureapp/screens/models/client_model.dart';
import 'package:coutureapp/screens/models/commande_model.dart';

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
        stream: clientService.getClients(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final clients = snapshot.data!;

          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return ListTile(
                title: Text(client.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Address: ${client.address}'),
                    Text('phoneNumber: ${client.phoneNumber}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await clientService.supprimerClient(client.id);
                  },
                ),
                onTap: () async {
                  List<CommandeModel> commandes =
                      await clientService.getClientCommandes(client.commandesIds);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientDetailScreen(client: client, commandes: commandes),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

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
            Text('Name: ${client.name}', style: TextStyle(fontSize: 20)),
            Text('Address: ${client.address}'),
            Text('phoneNumber: ${client.phoneNumber}'),
            SizedBox(height: 20),
            Text('Commandes:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: commandes.length,
                itemBuilder: (context, index) {
                  final commande = commandes[index];
                  return ListTile(
                    title: Text(commande.description),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Statut: ${commande.status}'),
                        if (commande.datePlanifiee != null)
                          Text('Date Planifiée: ${commande.datePlanifiee}'),
                        if (commande.dateLivraison != null)
                          Text('Date de Livraison: ${commande.dateLivraison}'),
                      ],
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
