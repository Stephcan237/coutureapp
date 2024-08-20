import 'package:flutter/material.dart';
import 'package:coutureapp/screens/models/cloth_model.dart';

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
          child: ListTile(
            leading: Image.network(cloth.imageUrl),
            title: Text(cloth.name),
            subtitle: Text(cloth.description),
            onTap: () {
              // Action à effectuer lors de la sélection d'un modèle de vêtement
            },
          ),
        );
      },
    );
  }
}
