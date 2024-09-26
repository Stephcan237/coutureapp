import 'dart:io';

import 'package:coutureapp/services/ges.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransitionPage extends StatefulWidget {
  const TransitionPage({super.key});

  @override
  State<TransitionPage> createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _localisationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<File?> _selectedImages = [null, null]; // Limité à deux images

  // Méthode pour sélectionner une image
  Future<void> _pickImage(int index, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImages[index] = File(pickedFile.path);
      });
    }
  }

  void configuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('config', "true");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Configurez votre Maison de couture"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Nom la maison de couture',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez le nom';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _localisationController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez la localisation';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Entrez une description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez une description';
                  }
                  return null;
                },
                maxLines: 5,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  _showImageSourceDialog(0);
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _selectedImages[0] != null
                      ? Image.file(
                          _selectedImages[0]!,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.camera_alt, color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Couture().addMaisonCouture(
                          _nomController.text,
                          _localisationController.text,
                          _descriptionController.text,
                          _selectedImages[0]!);
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text("Terminer")),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sélectionner une image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Depuis la galerie'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(index, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Prendre une photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(index, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
