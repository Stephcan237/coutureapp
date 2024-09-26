import 'package:flutter/material.dart';
import 'package:coutureapp/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';
import 'package:coutureapp/screens/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _login(BuildContext context) async {
    setState(() {
      _isLoading = true; // Début du chargement
    });
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      AppUser? utilisateur = await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      if (utilisateur != null) {
        if (utilisateur.role == 'Client') {
          Navigator.pushReplacementNamed(context, '/client_dashboard');
        } else if (utilisateur.role == 'Couturier') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('config', "true");
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Erreur lors de la connexion. Veuillez vérifier vos informations.')),
        );

        setState(() {
          _isLoading = false; // Début du chargement
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête avec une courbure et une couleur violette
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF6200EE), // Violet primaire
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Center(
                child: Text(
                  'Connexion Couture',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    // Email input
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.email, color: Color(0xFF6200EE)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir une adresse e-mail';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Password input
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF6200EE)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir un mot de passe';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: _isLoading
                          ? Center(
                              child:
                                  CircularProgressIndicator()) // Affichage du loader si la connexion est en cours
                          : ElevatedButton(
                              onPressed: () async {
                                _login(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                backgroundColor:
                                    Color(0xFF6200EE), // Violet primaire
                                elevation: 5,
                              ),
                              child: Text(
                                'Connexion',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                    // Register link
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        "Vous n'avez pas de compte ? Inscription",
                        style: TextStyle(
                          color: Color(0xFF6200EE),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
