import 'package:flutter/material.dart';

class NewClientScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Client'),
        backgroundColor: Color(0xFF3E4A89),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: contactController,
              decoration: InputDecoration(labelText: 'Contact'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Ajouter'),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    contactController.text.isNotEmpty) {
                  Navigator.pop(context, {
                    'name': nameController.text,
                    'contact': contactController.text,
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
