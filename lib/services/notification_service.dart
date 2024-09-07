import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  static const String serverToken = 'YOUR_SERVER_KEY_HERE';  // Remplacez par votre clé serveur FCM

  static Future<void> envoyerNotification(String titre, String message, String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': message, 'title': titre},
            'priority': 'high',
            'to': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Notification envoyée avec succès');
      } else {
        print('Échec de l\'envoi de la notification : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de la notification : $e');
      rethrow;
    }
  }
}
