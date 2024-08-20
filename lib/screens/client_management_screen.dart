import 'package:flutter/material.dart';
import 'screens/new_client_screen.dart';

class ClientManagementScreen extends StatefulWidget {
  @override
  _ClientManagementScreenState createState() => _ClientManagementScreenState();
}

class _ClientManagementScreenState extends State<ClientManagementScreen> {
  List<Map<String, dynamic>> clients = [
    {'name': 'Client A', 'contact': 'clienta@example.com'},
    {'name': 'Client B', 'contact': 'clientb@example.com'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Clients'),
        backgroundColor: Color(0xFF3E4A89),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewClientScreen()),
              );
              if (result != null) {
                setState(() {
                  clients.add(result);
                });
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(clients[index]['name']),
            subtitle: Text(clients[index]['contact']),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  clients.removeAt(index);
                });
              },
            ),
            onTap: () {
              // Action pour afficher les détails du client
            },
          );
        },
      ),
    );
  }
}
