import 'package:flutter/material.dart';
import 'package:coutureapp/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';
import 'package:coutureapp/screens/models/app_user.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _login(BuildContext context) async {
    final authService = Provider.of<FirebaseAuthService>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      AppUser? utilisateur = await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      if (utilisateur != null) {
        if (utilisateur.role == 'Client') {
          Navigator.pushReplacementNamed(context, '/client_dashboard');
        } else if (utilisateur.role == 'Couturier') {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          print('Rôle non défini');
        }
      } else {
        print('Erreur lors de la connexion');
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
            SizedBox(height: 200),
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
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, 0.2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir une adresse e-mail';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              border: InputBorder.none,
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir un mot de passe';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () => _login(context),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(143, 148, 251, 1),
                            Color.fromRGBO(143, 148, 251, 0.6),
                          ]),
                        ),
                        child: Center(
                          child: Text(
                            "Connexion",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgot_password');
                      },
                      child: Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(
                          color: Color.fromRGBO(143, 148, 251, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        "Vous n'avez pas de compte ? S'inscrire",
                        style: TextStyle(
                          color: Color.fromRGBO(143, 148, 251, 1),
                          fontWeight: FontWeight.bold,
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
