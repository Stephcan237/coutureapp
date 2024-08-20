import 'package:flutter/material.dart';

class MeasurementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prise de Mesures')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Client: yanzeu stephen'),
            subtitle: Text('Mesures: 90-60-90'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Naviguer vers les détails de la prise de mesures
            },
          ),
          // Ajouter plus de ListTile pour d'autres prises de mesures
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Naviguer vers l'ajout de nouvelles mesures
        },
      ),
    );
  }
}
