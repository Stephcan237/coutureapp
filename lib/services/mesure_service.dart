import 'package:coutureapp/screens/models/client_model.dart';

class MesuresService {
  static Map<String, dynamic> calculerMesures(String frontPhotoUrl, String sidePhotoUrl) {
    // Logique pour calculer les mesures à partir des photos
    // Retourne un Map<String, dynamic> avec les mesures calculées
    return {
      'taille': 170,
      'tour_de_poitrine': 90,
      'tour_de_taille': 75,
      'tour_de_hanche': 95,
      'longueur_de_bras': 60,
    };
  }

  static void mettreAJourMesuresClient(ClientModel client, Map<String, dynamic> mesures) {
    // Mettre à jour les mesures du client avec les nouvelles mesures calculées
    client.measurements.addAll(mesures);
  }
}