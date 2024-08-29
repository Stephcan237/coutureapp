import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coutureapp/services/gest_commandes.dart';
import 'package:coutureapp/screens/models/commande_model.dart';
import 'package:coutureapp/screens/screens/new_order_screen.dart';

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
                MaterialPageRoute(builder: (context) => NewOrderScreen()),
              );

              if (result != null && result is CommandeModel) {
                await commandeService.ajouterCommande(result);
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<CommandeModel>>(
        stream: commandeService.getCommandes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final commandes = snapshot.data!;

          return Column(
            children: <Widget>[
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
                          Text('Priorité: ${commande.status}'),
                          if (commande.datePlanifiee != null)
                            Text('Date Planifiée: ${commande.datePlanifiee}'),
                          if (commande.dateLivraison != null)
                            Text('Date de Livraison: ${commande.dateLivraison}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.event),
                            onPressed: () async {
                              _selectDate(context, (date) async {
                                await commandeService.planifierCommande(
                                    commande.id, date);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.local_shipping),
                            onPressed: () async {
                              _selectDate(context, (date) async {
                                await commandeService.planifierLivraison(
                                    commande.id, date);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await commandeService.supprimerCommande(commande.id);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Logique pour afficher les détails ou modifier la commande
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      commandes.sort((a, b) => a.status.compareTo(b.status));
                    });
                  },
                  child: Text('Classer par Priorité'),
                ),
              ),
            ],
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
