import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coutureapp/services/firebase_auth_service.dart';
import 'package:coutureapp/screens/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  final ValueNotifier<String> roleNotifier = ValueNotifier<String>('Client');

  void _register(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true; // Début du chargement
    });
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      if (passwordController.text == confirmPasswordController.text) {
        AppUser? user = await authService.signUpWithEmailAndPassword(
          emailController.text,
          passwordController.text,
          roleNotifier.value, // Passer le rôle ici
        );

        if (user != null) {
          await prefs.setString('config', "false");
          setState(() {
            _isLoading = false; // Début du chargement
          });
          if (roleNotifier.value == "Couturier") {
            Navigator.pushReplacementNamed(context, '/transition');
          } else {
            Navigator.pushReplacementNamed(context, '/login');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erreur lors de l\'inscription. Veuillez vérifier vos informations.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Les mots de passe ne correspondent pas')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // En-tête avec la couleur violette
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
                  'Inscription Couture',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          // Champ email
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
                              prefixIcon:
                                  Icon(Icons.email, color: Color(0xFF6200EE)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir une adresse e-mail';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          // Champ mot de passe
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              labelStyle: TextStyle(color: Colors.grey[700]),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon:
                                  Icon(Icons.lock, color: Color(0xFF6200EE)),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir un mot de passe';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          // Champ confirmer mot de passe
                          TextFormField(
                            controller: confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirmer le mot de passe',
                              labelStyle: TextStyle(color: Colors.grey[700]),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon:
                                  Icon(Icons.lock, color: Color(0xFF6200EE)),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez confirmer votre mot de passe';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          // Sélecteur de rôle
                          ValueListenableBuilder<String>(
                            valueListenable: roleNotifier,
                            builder: (context, value, child) {
                              return DropdownButtonFormField<String>(
                                value: value,
                                decoration: InputDecoration(
                                  labelText: 'Rôle',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                items: <String>['Client', 'Couturier']
                                    .map((String role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    roleNotifier.value = newValue;
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    // Bouton s'inscrire
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: _isLoading
                          ? Center(
                              child:
                                  CircularProgressIndicator()) // Affichage du loader si la connexion est en cours
                          : ElevatedButton(
                              onPressed: () => _register(context),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                backgroundColor:
                                    Color(0xFF6200EE), // Violet primaire
                                elevation: 5,
                              ),
                              child: Text(
                                "S'inscrire",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                    // Lien pour connexion
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Vous avez déjà un compte ? Connexion",
                        style: TextStyle(
                          color: Color(0xFF6200EE),
                          fontSize: 16,
                        ),
                      ),
                    ),
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
