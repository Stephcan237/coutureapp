import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
        backgroundColor: Color(0xFF3E4A89),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Paramètres de l\'Application',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Modifier le Profil'),
              leading: Icon(Icons.person),
              onTap: () {
                // Action pour modifier le profil
              },
            ),
            ListTile(
              title: Text('Notifications'),
              leading: Icon(Icons.notifications),
              onTap: () {
                // Action pour les paramètres de notifications
              },
            ),
            ListTile(
              title: Text('Thème'),
              leading: Icon(Icons.color_lens),
              onTap: () {
                // Action pour changer le thème
              },
            ),
            ListTile(
              title: Text('Sécurité'),
              leading: Icon(Icons.lock),
              onTap: () {
                // Action pour les paramètres de sécurité
              },
            ),
            ListTile(
              title: Text('Déconnexion'),
              leading: Icon(Icons.logout),
              onTap: () {
                // Action pour déconnecter l'utilisateur
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
