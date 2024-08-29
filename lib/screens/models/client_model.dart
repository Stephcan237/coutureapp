class ClientModel {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final Map<String, double> measurements; // Exemple: {'Tour de poitrine': 90.0, 'Tour de taille': 70.0}
  final List<String> commandesIds; // Liste des IDs des commandes associées

  ClientModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.measurements,
    required this.commandesIds,
  });

  factory ClientModel.fromMap(Map<String, dynamic> data) {
    return ClientModel(
      id: data['id'],
      name: data['name'],
      address: data['address'],
      phoneNumber: data['phoneNumber'],
      measurements: Map<String, double>.from(data['measurements']),
      commandesIds: List<String>.from(data['commandesIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'measurements': measurements,
      'commandesIds': commandesIds,
    };
  }
}
