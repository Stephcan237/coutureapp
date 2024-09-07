import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coutureapp/screens/models/client_model.dart';
import 'package:coutureapp/screens/models/commande_model.dart';

class ClientService {
  final CollectionReference clientsCollection =
      FirebaseFirestore.instance.collection('clients');

  Stream<List<ClientModel>> getClients() {
    try {
      return clientsCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => ClientModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList());
    } catch (e) {
      print('Erreur lors de la récupération des clients : $e');
      rethrow;
    }
  }

  Future<void> ajouterClient(ClientModel client) async {
    try {
      await clientsCollection.doc(client.id).set(client.toMap());
    } catch (e) {
      print('Erreur lors de l\'ajout du client : $e');
      rethrow;
    }
  }

  Future<void> mettreAJourClient(ClientModel client) async {
    try {
      await clientsCollection.doc(client.id).update(client.toMap());
    } catch (e) {
      print('Erreur lors de la mise à jour du client : $e');
      rethrow;
    }
  }

  Future<void> supprimerClient(String clientId) async {
    try {
      await clientsCollection.doc(clientId).delete();
    } catch (e) {
      print('Erreur lors de la suppression du client : $e');
      rethrow;
    }
  }

  Future<ClientModel?> getClientById(String clientId) async {
    try {
      DocumentSnapshot doc = await clientsCollection.doc(clientId).get();
      if (doc.exists) {
        return ClientModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération du client : $e');
      rethrow;
    }
  }

  Future<List<CommandeModel>> getClientCommandes(List<String> commandeIds) async {
    try {
      List<CommandeModel> commandes = [];
      for (String commandeId in commandeIds) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('commandes')
            .doc(commandeId)
            .get();
        if (doc.exists) {
          commandes.add(CommandeModel.fromMap(doc.data() as Map<String, dynamic>));
        }
      }
      return commandes;
    } catch (e) {
      print('Erreur lors de la récupération des commandes du client : $e');
      rethrow;
    }
  }
}