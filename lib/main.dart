import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/measurement_screen.dart';
import 'screens/order_management_screen.dart';
import 'screens/client_management_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/screens/new_client_screen.dart';
import 'screens/settings_screen.dart';
import 'services/firebase_auth_service.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:coutureapp/screens/models/app_user.dart';
import 'package:coutureapp/screens/screens/client_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FirebaseAuthService(),
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
          return user == null ? LoginScreen() : DashboardScreen();
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
                    OrderManagementScreen(),
                    Colors.transparent,
                  ),
                  _buildDashboardCard(
                    context,
                    'Gestion des Clients',
                    Icons.people,
                    ClientManagementScreen(),
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

  Widget _buildDashboardCard(BuildContext context, String title, IconData icon, Widget destination, Color color) {
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
