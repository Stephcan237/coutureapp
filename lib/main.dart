import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'screens/measurement_screen.dart';
import 'screens/order_management_screen.dart';
import 'screens/client_management_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/screens/new_client_screen.dart';
import 'screens/settings_screen.dart';
import 'services/firebase_auth_service.dart';
import 'services/gest_commandes.dart';
import 'services/gest_clients.dart';
import 'package:coutureapp/screens/models/app_user.dart';
import 'package:coutureapp/screens/screens/client_dashboard.dart';
import 'package:coutureapp/services/vetement_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      // Handle the notification and show it in the app if needed
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FirebaseAuthService(),
        ),
        Provider<CommandeService>(
          create: (context) => CommandeService(),
        ),
        Provider<ClientService>(
          create: (context) => ClientService(),
        ),
        Provider(create: (context) => VetementService())
      ],
      child: MaterialApp(
        title: 'Gestion Atelier Couture',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/dashboard': (context) => DashboardScreen(),
          '/client_management': (context) => ClientManagementScreen(),
          '/new_client': (context) => NewClientScreen(),
          '/client_dashboard': (context) => ClientDashboard(),
          '/couturier_dashboard': (context) => DashboardScreen(),
        },
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseAuthService = Provider.of<FirebaseAuthService>(context);

    return StreamBuilder<AppUser?>(
      stream: firebaseAuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          } else if (user.role == 'Client') {
            return ClientDashboard();
          } else if (user.role == 'Couturier') {
            return DashboardScreen();
          } else {
            return Scaffold(
              body: Center(child: Text('Rôle non défini')),
            );
          }
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<FirebaseAuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.jpg', height: 40),
            SizedBox(width: 10),
            Text('Tableau de Bord'),
          ],
        ),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Bienvenue dans l\'application de gestion de votre atelier de couture!',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: <Widget>[
                  _buildDashboardCard(
                    context,
                    'Prise de Mesures',
                    Icons.straighten,
                    MeasurementScreen(),
                    Colors.transparent,
                  ),
                  _buildDashboardCard(
                    context,
                    'Gestion des Commandes',
                    Icons.assignment,
                    OrderManagementScreen(), // Utilisation de la gestion des commandes
                    Colors.transparent,
                  ),
                  _buildDashboardCard(
                    context,
                    'Gestion des Clients',
                    Icons.people,
                    ClientManagementScreen(), // Utilisation de la gestion des clients
                    Colors.transparent,
                  ),
                  _buildDashboardCard(
                    context,
                    'Notifications',
                    Icons.notifications,
                    NotificationScreen(),
                    Colors.transparent,
                  ),
                  _buildDashboardCard(
                    context,
                    'Paramètres',
                    Icons.settings,
                    SettingsScreen(),
                    Colors.transparent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, IconData icon,
      Widget destination, Color color) {
    return Card(
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: color,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 40.0, color: Colors.white),
              SizedBox(height: 10.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
