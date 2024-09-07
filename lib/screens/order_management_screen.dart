import 'package:flutter/material.dart';
import 'package:coutureapp/screens/models/commande_model.dart';
import 'package:coutureapp/services/gest_commandes.dart';
import 'package:provider/provider.dart';
import 'package:coutureapp/screens/screens/new_order_screen.dart';
import 'package:coutureapp/screens/screens/order_detail_screen.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final commandeService = Provider.of<CommandeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Commandes'),
        backgroundColor: Color(0xFF3E4A89),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewOrderScreen(commande: null, cloth: null)),
              );

              if (result != null && result is CommandeModel) {
                final client = await commandeService.getClientById(result.clientId);
                
                if (client != null) {
                  await commandeService.ajouterCommande(result, client);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Commande ajoutée avec succès')),
                  );
                } else {
                  // Gérer le cas où le client est introuvable
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Client introuvable')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<CommandeModel>>(
        stream: commandeService.getCommandes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune commande trouvée.'));
          }

          final commandes = snapshot.data!;

          return ListView.builder(
            itemCount: commandes.length,
            itemBuilder: (context, index) {
              final commande = commandes[index];
              return Card(
                margin: EdgeInsets.all(8.0),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.event),
                        onPressed: () async {
                          _selectDate(context, (date) async {
                            await commandeService.planifierCommande(commande.id, date);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.local_shipping),
                        onPressed: () async {
                          _selectDate(context, (date) async {
                            await commandeService.planifierLivraison(commande.id, date);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await commandeService.supprimerCommande(commande.id, commande.clientId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Commande supprimée avec succès')),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(commande: commande),
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

  void _selectDate(BuildContext context, Function(DateTime) onDateSelected) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }
}