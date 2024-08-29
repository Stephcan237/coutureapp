import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coutureapp/screens/models/commande_model.dart';

class CommandeService {
  final CollectionReference commandesCollection =
      FirebaseFirestore.instance.collection('commandes');

  Future<void> ajouterCommande(CommandeModel commande) async {
    try {
      String id = commande.id.isNotEmpty ? commande.id : commandesCollection.doc().id;
      commande = CommandeModel(
        id: id,
        clientId: commande.clientId,
        description: commande.description,
        status: commande.status,
        dateCreation: commande.dateCreation,
        dateCompletion: commande.dateCompletion,
        datePlanifiee: commande.datePlanifiee,
        dateLivraison: commande.dateLivraison,
      );
      await commandesCollection.doc(id).set(commande.toMap());
    } catch (e) {
      print('Erreur lors de l\'ajout de la commande : $e');
      throw Exception('Impossible d\'ajouter la commande.');
    }
  }

  Future<void> mettreAJourCommande(CommandeModel commande) async {
    try {
      await commandesCollection.doc(commande.id).update(commande.toMap());
    } catch (e) {
      print('Erreur lors de la mise à jour de la commande : $e');
      throw Exception('Impossible de mettre à jour la commande.');
    }
  }

  Future<void> supprimerCommande(String id) async {
    try {
      await commandesCollection.doc(id).delete();
    } catch (e) {
      print('Erreur lors de la suppression de la commande : $e');
      throw Exception('Impossible de supprimer la commande.');
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
      throw Exception('Impossible de récupérer la commande.');
    }
  }

  Future<void> planifierCommande(String commandeId, DateTime datePlanifiee) async {
    try {
      await commandesCollection.doc(commandeId).update({
        'datePlanifiee': datePlanifiee.toIso8601String(),
      });
    } catch (e) {
      print('Erreur lors de la planification de la commande : $e');
      throw Exception('Impossible de planifier la commande.');
    }
  }

  Future<void> planifierLivraison(String commandeId, DateTime dateLivraison) async {
    try {
      await commandesCollection.doc(commandeId).update({
        'dateLivraison': dateLivraison.toIso8601String(),
      });
    } catch (e) {
      print('Erreur lors de la planification de la livraison : $e');
      throw Exception('Impossible de planifier la livraison.');
    }
  }

  Stream<List<CommandeModel>> getCommandes() {
    try {
      return commandesCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => CommandeModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList());
    } catch (e) {
      print('Erreur lors de la récupération des commandes : $e');
      throw Exception('Impossible de récupérer les commandes.');
    }
  }
}
