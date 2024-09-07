import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coutureapp/screens/models/commande_model.dart';
import 'package:coutureapp/screens/models/client_model.dart';

class CommandeService {
  final CollectionReference commandesCollection =
      FirebaseFirestore.instance.collection('commandes');
  final CollectionReference clientsCollection =
      FirebaseFirestore.instance.collection('clients');

  Future<void> ajouterCommande(CommandeModel commande, ClientModel client) async {
    try {
      await commandesCollection.doc(commande.id).set(commande.toMap());
      await clientsCollection.doc(client.id).update({
        'commandeIds': FieldValue.arrayUnion([commande.id]),
      });
    } catch (e) {
      print('Erreur lors de l\'ajout de la commande : $e');
      rethrow;
    }
  }

  Future<void> mettreAJourCommande(CommandeModel commande) async {
    try {
      await commandesCollection.doc(commande.id).update(commande.toMap());
    } catch (e) {
      print('Erreur lors de la mise à jour de la commande : $e');
      rethrow;
    }
  }

  Future<void> supprimerCommande(String commandeId, String clientId) async {
    try {
      await commandesCollection.doc(commandeId).delete();
      await clientsCollection.doc(clientId).update({
        'commandeIds': FieldValue.arrayRemove([commandeId]),
      });
    } catch (e) {
      print('Erreur lors de la suppression de la commande : $e');
      rethrow;
    }
  }

  Future<CommandeModel?> getCommandeById(String commandeId) async {
    try {
      DocumentSnapshot doc = await commandesCollection.doc(commandeId).get();
      if (doc.exists) {
        return CommandeModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de la commande : $e');
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

  Future<List<CommandeModel>> getCommandesByClientId(String clientId) async {
    try {
      QuerySnapshot snapshot = await commandesCollection
          .where('clientId', isEqualTo: clientId)
          .orderBy('dateCreation', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => CommandeModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des commandes du client : $e');
      rethrow;
    }
  }

  Future<void> planifierCommande(String commandeId, DateTime datePlanifiee) async {
    try {
      await commandesCollection.doc(commandeId).update({
        'datePlanifiee': Timestamp.fromDate(datePlanifiee),
      });
    } catch (e) {
      print('Erreur lors de la planification de la commande : $e');
      rethrow;
    }
  }

  Future<void> planifierLivraison(String commandeId, DateTime dateLivraison) async {
    try {
      await commandesCollection.doc(commandeId).update({
        'dateLivraison': Timestamp.fromDate(dateLivraison),
      });
    } catch (e) {
      print('Erreur lors de la planification de la livraison : $e');
      rethrow;
    }
  }

  Stream<List<CommandeModel>> getCommandes() {
    try {
      return commandesCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => CommandeModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList());
    } catch (e) {
      print('Erreur lors de la récupération des commandes : $e');
      rethrow;
    }
  }
}
