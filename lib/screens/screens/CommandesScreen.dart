import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coutureapp/screens/models/MaisonCouture.dart';
import 'package:coutureapp/screens/models/commande_model.dart';
import 'package:coutureapp/screens/screens/DetailsCommande.dart';
import 'package:coutureapp/services/ges.dart';
import 'package:flutter/material.dart';

class CommandesScreen extends StatefulWidget {
  @override
  _CommandesScreenState createState() => _CommandesScreenState();
}

class _CommandesScreenState extends State<CommandesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ModeleMaisonCouture> commandeValide = [];
  List<ModeleMaisonCouture> commandeEnattente = [];
  Future<QuerySnapshot<Object?>>? futurecommandeValide;
  Future<QuerySnapshot<Object?>>? futurecommandeEnattente;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchReservations();
  }

  void fetchReservations() {
    setState(() {
      futurecommandeValide = Couture().geCommandeValide();
      futurecommandeEnattente = Couture().geCommandeAttente();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Commandes',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFF6200EE), // Couleur violette de l'indicateur
          labelColor: Colors.grey.shade800,
          unselectedLabelColor: Colors.grey.shade400,
          tabs: [
            Tab(text: 'En attente'),
            Tab(text: 'Validé'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEnAttenteTab(),
          _buildValideTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  // Contenu pour l'onglet "En attente"
  Widget _buildEnAttenteTab() {
    return FutureBuilder<QuerySnapshot>(
        future: futurecommandeEnattente,
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
            return const Center(child: Text("Pas de Commandes en attente"));
          } else {
            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
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
                      onTap: () {}, child: _buildCommandeCard(commande)),
                );
              }).toList(),
            );
          }
        });
  }

  // Contenu pour l'onglet "Validé"
  Widget _buildValideTab() {
    return FutureBuilder<QuerySnapshot>(
        future: futurecommandeValide,
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
            return const Center(child: Text("Pas de commandes validé"));
          } else {
            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
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
                      onTap: () {}, child: _buildCommandeCard(commande)),
                );
              }).toList(),
            );
          }
        });
  }

  // Widget pour afficher chaque commande sous forme de carte
  Widget _buildCommandeCard(CommandeModel commande) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommandeDetailsPage(commande: commande),
          ),
        );
      },
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

  // Navigation bar en bas
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Commandes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ],
      selectedItemColor: Color(0xFF6200EE), // Couleur violette
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/client_dashboard');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/commandes');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/parametres');
            break;
        }
      },
    );
  }
}
