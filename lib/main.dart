import 'package:coutureapp/screens/ajout_model.dart';
import 'package:coutureapp/screens/models/MaisonCouture.dart';
import 'package:coutureapp/screens/screens/CommandesScreen.dart';
import 'package:coutureapp/screens/screens/mes_modele.dart';
import 'package:coutureapp/screens/transition.dart';
import 'package:coutureapp/services/ges.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/order_management_screen.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/settings_screen.dart';
import 'services/firebase_auth_service.dart';
import 'services/gest_commandes.dart'; // Assurez-vous que le chemin est correct
import 'services/gest_clients.dart';
import 'package:coutureapp/screens/models/app_user.dart';
import 'package:coutureapp/screens/screens/client_dashboard.dart';

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
      ],
      child: MaterialApp(
        title: 'Gestion Atelier Couture',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => LoginScreen(),
          '/transition': (context) => const TransitionPage(),
          '/register': (context) => RegisterScreen(),
          '/dashboard': (context) => DashboardScreen(),
          '/commandes': (context) => CommandesScreen(),
          '/client_dashboard': (context) => const ClientDashboard(),
        },
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late SharedPreferences prefs;
  String config = 'false';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load();
  }

  void _load() async {
    prefs = await SharedPreferences.getInstance();
    try {
      config = prefs.getString('config')!;
    } catch (e) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('config', "false");
      _load();
    }
  }

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
          } else if (user.role == 'Couturier' && config == 'true') {
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

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  MaisonCouture maison = MaisonCouture(
      nom: 'Inconnu',
      localisation: 'Inconnu',
      description: 'Inconu',
      image: 'Inconnu',
      id_couturuer: 'Inconnu');

  @override
  void initState() {
    super.initState();

    // Appel correct de la méthode asynchrone
    _loadMaisonInfo();
  }

  Future<void> _loadMaisonInfo() async {
    try {
      final maisonInfo = await Couture().getMaisonCoutureByIdCouturier();
      if (maisonInfo != null) {
        setState(() {
          maison = maisonInfo;
        });
      } else {
        // Gestion des données non trouvées
        print("Aucune donnée trouvée");
      }
    } catch (e) {
      print("Erreur lors de la récupération des informations: $e");
    }
  }

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
        backgroundColor: Color(0xFF6200EE), // Utilisation du violet défini
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
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
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
                    'Gestion des Commandes',
                    Icons.assignment,
                    OrderManagementScreen(
                      maisoncouture: maison,
                    ),
                    Color(0xFF6200EE), // Violet primaire
                  ),
                  _buildDashboardCard(
                    context,
                    'Ajouter un modèle',
                    Icons.add,
                    AjoutmodelPage(
                      maisoncouture: maison,
                    ),
                    Color(0xFF6200EE), // Violet primaire
                  ),
                  _buildDashboardCard(
                    context,
                    'Mes modèles',
                    Icons.house,
                    Mes_modele(
                      maison: maison,
                    ),
                    Color(0xFF6200EE), // Violet primaire
                  ),
                  _buildDashboardCard(
                    context,
                    'Paramètres',
                    Icons.settings,
                    SettingsScreen(),
                    Color(0xFF6200EE),
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
