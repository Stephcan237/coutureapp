import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> sendNotification(String token, String title, String message) async {
  await FirebaseMessaging.instance.sendMessage(
    to: token,
    data: {
      'title': title,
      'message': message,
    },
  );
}
