import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coutureapp/screens/models/MaisonCouture.dart';
import 'package:coutureapp/services/ges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coutureapp/services/gest_commandes.dart';
import 'package:coutureapp/screens/models/commande_model.dart';

class OrderManagementScreen extends StatefulWidget {
  final MaisonCouture maisoncouture;

  const OrderManagementScreen({super.key, required this.maisoncouture});

  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  List<CommandeModel> commandes = [];
  Future<QuerySnapshot<Object?>>? futurecommandes;

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  void fetchReservations() {
    setState(() {
      futurecommandes =
          Couture().getCommandeCouturier(widget.maisoncouture.nom);
    });
  }

  @override
  Widget build(BuildContext context) {
    final commandeService = Provider.of<CommandeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Commandes'),
        backgroundColor: Color(0xFF3E4A89),
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
              FutureBuilder<QuerySnapshot>(
                  future: futurecommandes,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.purple,
                      ));
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            "Vous n'etes pas connecté ou n'avez pas de commandes"),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("Pas de commandes"));
                    } else {
                      return ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          CommandeModel commande = CommandeModel(
                            id: data['id'],
                            clientId: data['clientId'],
                            description: data['description'],
                            status: data['status'],
                            dateCreation: data['dateCreation'],
                            dateCompletion: data['dateCompletion'],
                            datePlanifiee: data['datePlanifiee'],
                            dateLivraison: data['dateLivraison'],
                            modeleId: data['modeleId'],
                          );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: GestureDetector(
                                onTap: () {},
                                child: _buildCommandeCard(commande)),
                          );
                        }).toList(),
                      );
                    }
                  }),
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

  void _selectDate(
      BuildContext context, Function(DateTime) onDateSelected) async {
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

  Widget _buildCommandeCard(CommandeModel commande) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Identifiant : ${commande.clientId}',
                  style: TextStyle(
                    color: Color(0xFF6200EE), // Texte en violet
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  commande.description,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
