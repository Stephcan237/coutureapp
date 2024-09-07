import 'package:flutter/material.dart';
import 'package:coutureapp/screens/models/cloth_model.dart';
import 'package:coutureapp/screens/screens/new_order_screen.dart';

class ClothSelectionScreen extends StatelessWidget {
  final List<ClothModel> clothModels;

  ClothSelectionScreen({required this.clothModels});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: clothModels.length,
      itemBuilder: (context, index) {
        final cloth = clothModels[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.asset(cloth.imageUrl), // Utilisation de l'image à partir des assets
            title: Text(cloth.name),
            subtitle: Text(cloth.description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewOrderScreen(cloth: cloth, commande: null),
                ),
              );
            },
          ),
        );
      },
    );
  }
}