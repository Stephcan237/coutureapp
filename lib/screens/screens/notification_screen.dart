import 'package:flutter/material.dart';
import 'package:coutureapp/screens/models/notification_model.dart'; // Import du modèle NotificationModel

class NotificationScreen extends StatelessWidget {
  final List<NotificationModel> notifications;

  NotificationScreen({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(notification.title),
              subtitle: Text('${notification.message}\n${notification.timestamp.toLocal()}'),
            ),
          );
        },
      ),
    );
  }
}
