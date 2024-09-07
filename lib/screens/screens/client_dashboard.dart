import 'package:flutter/material.dart';
import 'package:coutureapp/screens/models/cloth_model.dart';
import 'package:coutureapp/screens/models/notification_model.dart' as notif_model;
import 'package:coutureapp/screens/cloth_selection_screen.dart';
import 'package:coutureapp/screens/screens/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:coutureapp/services/firebase_auth_service.dart';
import 'package:coutureapp/services/vetement_service.dart'; // Importer le service de gestion des vêtements

class ClientDashboard extends StatefulWidget {
  @override
  _ClientDashboardState createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  List<ClothModel> clothModels = [];
  List<notif_model.NotificationModel> notifications = [];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      print("FirebaseMessaging token: $token");
      // Envoyer le token au backend pour les notifications futures
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          notifications.add(
            notif_model.NotificationModel(
              id: message.messageId ?? DateTime.now().toString(),
              title: message.notification!.title ?? 'Notification',
              message: message.notification!.body ?? '',
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    });

    // Charger les modèles de vêtements depuis le service
    final vetementService = Provider.of<VetementService>(context, listen: false);
    vetementService.getVetements().then((models) {
      setState(() {
        clothModels = models;
      });
    });

    // Ajouter des notifications par défaut si nécessaire
    notifications.addAll([
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<FirebaseAuthService>(context);

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
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await authService.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
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