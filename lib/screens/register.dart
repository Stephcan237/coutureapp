import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coutureapp/services/firebase_auth_service.dart';
import 'package:coutureapp/screens/models/app_user.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ValueNotifier<String> roleNotifier = ValueNotifier<String>('Client');

  void _register(BuildContext context) async {
    final authService = Provider.of<FirebaseAuthService>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      if (passwordController.text == confirmPasswordController.text) {
        AppUser? user = await authService.signUpWithEmailAndPassword(
          emailController.text,
          passwordController.text,
          roleNotifier.value, // Passer le rôle ici
        );

        if (user != null) {
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          // Afficher une erreur utilisateur
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l\'inscription')),
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
                              labelText: 'Email',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: InputBorder.none,
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: InputBorder.none,
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          ValueListenableBuilder<String>(
                            valueListenable: roleNotifier,
                            builder: (context, value, child) {
                              return DropdownButtonFormField<String>(
                                value: value,
                                decoration: InputDecoration(
                                  labelText: 'Role',
                                  border: InputBorder.none,
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
                    GestureDetector(
                      onTap: () => _register(context),
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
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 70),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Already have an account? Login",
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
