import 'package:coutureapp/screens/models/cloth_model.dart';

class VetementService {
  // Liste des modèles de vêtements
  final List<ClothModel> _vetements = [
    ClothModel(
      id: '1',
      name: 'Robe élégante',
      imageUrl: 'assets/images/robe.jpg',
      description: 'Une robe élégante pour les soirées.',
    ),
    ClothModel(
      id: '2',
      name: 'T-shirt décontracté',
      imageUrl: 'assets/images/T-shirt.jpg',
      description: 'Un t-shirt parfait pour les sorties décontractées.',
    ),
    // Ajoutez plus de modèles de vêtements ici
  ];

  // Méthode pour récupérer la liste des modèles de vêtements
  Future<List<ClothModel>> getVetements() async {
    return _vetements;
  }

  // Méthode pour ajouter un nouveau modèle de vêtement
  Future<void> ajouterVetement(ClothModel vetement) async {
    _vetements.add(vetement);
  }
}