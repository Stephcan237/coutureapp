import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coutureapp/screens/login.dart';
import 'package:coutureapp/screens/models/MaisonCouture.dart';
import 'package:coutureapp/screens/screens/MaisonCouture.dart';
import 'package:coutureapp/screens/screens/PoidsTaillePhotoScreen.dart';
import 'package:coutureapp/services/ges.dart';
import 'package:flutter/material.dart';
import 'package:coutureapp/screens/models/notification_model.dart'
    as notif_model;

class ClientDashboard extends StatefulWidget {
  const ClientDashboard({super.key});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  List<MaisonCouture> maisoncouture = [];
  Future<QuerySnapshot<Object?>>? futureMaisoncouture;

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  void fetchReservations() {
    setState(() {
      futureMaisoncouture = Couture().getMaison();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Client'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.output),
              onPressed: () {
                // Action à exécuter lors du clic sur le bouton notification
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              }),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Action à exécuter lors du clic sur le bouton notification
              print("Notifications clicked");
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1.0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildClientInfo(),
            SizedBox(height: 20),
            _buildMaisonDeCoutures(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildClientInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE0CFFF), // Purple background
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yanzeu Stephane',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Client régulier',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Taille : 1m 70',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Poids : 70 Kg',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange, // Purple color
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Action à exécuter lorsque l'utilisateur appuie sur le bouton
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PoidsTaillePhotoScreen(),
                        ),
                      );
                      print('Prendre mesures');
                    },
                    child: Center(
                      child: Text(
                        'Prendre les mesures',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/clothes.png', // Replace with your image path
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaisonDeCoutures() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Les maisons de coutures',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
                future: futureMaisoncouture,
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
                    return const Center(
                        child: Text(
                            "Pas Maison de couture ou probleme de connexion"));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          snapshot.data!.docs.length, // Nombre d'éléments
                      itemBuilder: (BuildContext context, int index) {
                        // Récupération du document
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        // Création de l'objet MaisonCouture
                        MaisonCouture maisoncouture = MaisonCouture(
                          nom: data['nom'],
                          localisation: data['localisation'],
                          description: data['description'],
                          image: data['image'],
                          id_couturuer: data['id_couturuer'],
                        );

                        // Retourne chaque élément de la liste sous forme de Widget
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MaisonCouturePage(
                                      maisonCouture: maisoncouture),
                                ),
                              );
                            },
                            child: _buildMaisonCard(
                                maisoncouture), // Appel de la fonction pour construire l'affichage de la maison
                          ),
                        );
                      },
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildMaisonCard(MaisonCouture maison) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image de la maison de couture
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              maison.image,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          // Détails de la maison de couture
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maison.nom,
                  style: TextStyle(
                    color: Color(0xFF6200EE), // Texte en violet
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  maison.localisation,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  maison.description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Bouton pour voir les détails
          IconButton(
            icon: Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey.shade600),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MaisonCouturePage(maisonCouture: maison),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

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
      selectedItemColor: Color(0xFF6200EE), // Purple color
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(
                context, '/client_dashboard'); // Naviguer vers le dashboard
            break;
          case 1:
            Navigator.pushReplacementNamed(
                context, '/commandes'); // Naviguer vers les commandes
            break;
          case 2:
            Navigator.pushReplacementNamed(
                context, '/parametres'); // Naviguer vers les paramètres
            break;
        }
      },
    );
  }
}
