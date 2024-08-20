import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Nouvelle commande de yanzeu stephen'),
            subtitle: Text('Commande #002'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Naviguer vers les détails de la notification
            },
          ),
          // Ajouter plus de ListTile pour d'autres notifications
        ],
      ),
    );
  }
}
