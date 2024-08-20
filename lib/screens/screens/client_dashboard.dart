import 'package:flutter/material.dart';
import 'package:coutureapp/screens/models/cloth_model.dart';
import 'package:coutureapp/screens/models/notification_model.dart' as notif_model; // Alias pour éviter les conflits
import 'package:coutureapp/screens/cloth_selection_screen.dart';
import 'package:coutureapp/screens/screens/notification_screen.dart';

class ClientDashboard extends StatelessWidget {
  final List<ClothModel> clothModels = [
    ClothModel(
      id: '1',
      name: 'Robe élégante',
      imageUrl: 'https://example.com/robe1.jpg',
      description: 'Une robe élégante pour les soirées.',
    ),
    ClothModel(
      id: '2',
      name: 'T-shirt décontracté',
      imageUrl: 'https://example.com/tshirt1.jpg',
      description: 'Un t-shirt parfait pour les sorties décontractées.',
    ),
    // Ajoutez plus de modèles de vêtements ici
  ];

  final List<notif_model.NotificationModel> notifications = [ // Utilisez l'alias ici
    notif_model.NotificationModel(
      id: '1',
      title: 'Nouvelle collection',
      message: 'Découvrez notre nouvelle collection printemps-été.',
      timestamp: DateTime.now(),
    ),
    notif_model.NotificationModel(
      id: '2',
      title: 'Soldes',
      message: 'Profitez de nos soldes jusqu\'à -50% !',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
    ),
    // Ajoutez plus de notifications ici
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tableau de bord du client'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Modèles'),
              Tab(text: 'Notifications'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ClothSelectionScreen(clothModels: clothModels),
            NotificationScreen(notifications: notifications),
          ],
        ),
      ),
    );
  }
}
