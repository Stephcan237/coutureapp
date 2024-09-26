import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coutureapp/screens/models/MaisonCouture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Couture {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<QuerySnapshot> getMaison() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('maisoncouture').get();

      return querySnapshot;
    } catch (e) {
      print('Error fetching documents: $e');
      rethrow; // Optionnel : vous pouvez relancer l'exception ou gérer l'erreur d'une autre manière
    }
  }

  Future<QuerySnapshot> getModel(String maison) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('modelmaison')
          .where('maisonCouture', isEqualTo: maison)
          .get();

      return querySnapshot;
    } catch (e) {
      print('Error fetching documents: $e');
      rethrow; // Optionnel : vous pouvez relancer l'exception ou gérer l'erreur d'une autre manière
    }
  }

  Future<QuerySnapshot> geCommandeValide() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('commandemodel')
          .where('clientId', isEqualTo: _auth.currentUser!.uid)
          .where('status', isEqualTo: 'Valide')
          .get();

      return querySnapshot;
    } catch (e) {
      print('Error fetching documents: $e');
      rethrow; // Optionnel : vous pouvez relancer l'exception ou gérer l'erreur d'une autre manière
    }
  }

  Future<QuerySnapshot> geCommandeAttente() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('commandemodel')
          .where('clientId', isEqualTo: _auth.currentUser!.uid)
          .where('status', isEqualTo: 'En attente')
          .get();

      return querySnapshot;
    } catch (e) {
      print('Error fetching documents: $e');
      rethrow; // Optionnel : vous pouvez relancer l'exception ou gérer l'erreur d'une autre manière
    }
  }

  Future<QuerySnapshot> getCommandeCouturier(String maisonCouture) async {
    try {
      // Étape 1: Récupérer les modèles de la maison de couture donnée
      QuerySnapshot modelSnapshot = await FirebaseFirestore.instance
          .collection('commandemodel')
          .where('maisonCouture', isEqualTo: maisonCouture)
          .get();

      // Récupérer tous les idModel des modèles associés à cette maison de couture
      List<String> modelIds = modelSnapshot.docs.map((doc) => doc.id).toList();

      // Étape 2: Récupérer les commandes associées aux modèles de cette maison de couture
      QuerySnapshot commandeSnapshot = await FirebaseFirestore.instance
          .collection('commandemodel')
          .where('modeleId',
              whereIn: modelIds) // Filtrer par idModel correspondant
          .get();

      return commandeSnapshot;
    } catch (e) {
      print('Error fetching documents: $e');
      rethrow; // Vous pouvez relancer l'exception ou gérer l'erreur
    }
  }

  Future<void> addMaisonCouture(String nom, String localisation,
      String description, File imageFile) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (description != '') {
      // Enregistrement des données dans SharedPreferences
      await prefs.setString('nom', nom);
      await prefs.setString('localisation', localisation);
      await prefs.setString('description', description);

      try {
        // Étape 1 : Télécharger l'image dans Firebase Storage
        String imageFileName = imageFile.path.split('/').last;
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('images/$imageFileName');

        UploadTask uploadTask = storageRef.putFile(imageFile);

        // Attendre la fin du téléchargement
        final TaskSnapshot downloadUrl = await uploadTask;
        final String imageUrl = await downloadUrl.ref.getDownloadURL();

        // Enregistrement de l'URL de l'image dans SharedPreferences
        await prefs.setString('image', imageUrl);

        // Étape 2 : Sauvegarder les informations dans Firestore
        CollectionReference maisonCoutureCollection =
            FirebaseFirestore.instance.collection('maisoncouture');

        await maisonCoutureCollection.add({
          'nom': nom,
          'localisation': localisation,
          'description': description,
          'image': imageUrl, // URL de l'image sauvegardée
        });

        print("Maison de couture ajoutée avec succès !");
      } catch (error) {
        print("Erreur lors de l'ajout de la maison de couture: $error");
      }
    }
  }

  Future<MaisonCouture?> getMaisonCoutureByIdCouturier() async {
    try {
      // Référence à la collection 'maisoncouture'
      CollectionReference maisonsCouture =
          FirebaseFirestore.instance.collection('maisoncouture');

      // Rechercher la maison de couture avec l'id_couturuer
      QuerySnapshot querySnapshot = await maisonsCouture
          .where('id_couturuer', isEqualTo: _auth.currentUser?.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Récupérer le premier document correspondant
        DocumentSnapshot doc = querySnapshot.docs.first;

        // Créer un objet MaisonCouture avec les données récupérées
        MaisonCouture maisonCouture = MaisonCouture(
          nom: doc['nom'],
          localisation: doc['localisation'],
          description: doc['description'],
          image: doc['image'],
          id_couturuer: doc['id_couturuer'],
        );

        return maisonCouture;
      } else {
        print("Aucune maison de couture trouvée pour cet id_couturuer");
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération de la maison de couture: $e");
      return null;
    }
  }
}
