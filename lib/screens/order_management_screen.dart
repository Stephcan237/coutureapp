import 'package:flutter/material.dart';
import 'screens/new_order_screen.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  List<Map<String, dynamic>> orders = [
    {'name': 'Commande A', 'priority': 'Haute'},
    {'name': 'Commande B', 'priority': 'Moyenne'},
  ];

  void _addOrder(Map<String, dynamic> order) {
    setState(() {
      orders.add(order);
    });
  }

  void _removeOrder(int index) {
    setState(() {
      orders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
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
              if (result != null) {
                _addOrder(result);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(orders[index]['name']),
                  subtitle: Text('Priorité: ${orders[index]['priority']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeOrder(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  orders.sort((a, b) => a['priority'].compareTo(b['priority']));
                });
              },
              child: Text('Classer par Priorité'),
            ),
          ),
        ],
      ),
    );
  }
}
