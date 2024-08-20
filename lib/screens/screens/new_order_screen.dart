import 'package:flutter/material.dart';

class NewOrderScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Commande'),
        backgroundColor: Color(0xFF3E4A89),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nom de la Commande'),
            ),
            TextField(
              controller: priorityController,
              decoration: InputDecoration(labelText: 'Priorité'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Ajouter'),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    priorityController.text.isNotEmpty) {
                  Navigator.pop(context, {
                    'name': nameController.text,
                    'priority': priorityController.text,
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
