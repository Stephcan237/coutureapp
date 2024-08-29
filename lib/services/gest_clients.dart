import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coutureapp/screens/models/client_model.dart';
import 'package:coutureapp/screens/models/commande_model.dart';
import 'package:coutureapp/services/gest_commandes.dart';

class ClientService {
  final CollectionReference clientsCollection =
      FirebaseFirestore.instance.collection('clients');
  
  final CommandeService _commandeService = CommandeService();

  Future<void> ajouterClient(ClientModel client) async {
    await clientsCollection.doc(client.id).set(client.toMap());
  }

  Stream<List<ClientModel>> getClients() {
    return clientsCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ClientModel.fromMap(doc.data() as Map<String, dynamic>)).toList());
  }

  Future<void> supprimerClient(String id) async {
    await clientsCollection.doc(id).delete();
  }

  Future<void> modifierClient(ClientModel client) async {
    await clientsCollection.doc(client.id).update(client.toMap());
  }

  Future<List<CommandeModel>> getClientCommandes(List<String> commandesIds) async {
    List<CommandeModel> commandes = [];
    for (String id in commandesIds) {
      CommandeModel? commande = await _commandeService.getCommandeById(id);
      if (commande != null) {
        commandes.add(commande);
      }
    }
    return commandes;
  }
}
