import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PoidsTaillePhotoScreen extends StatefulWidget {
  @override
  _PoidsTaillePhotoScreenState createState() => _PoidsTaillePhotoScreenState();
}

class _PoidsTaillePhotoScreenState extends State<PoidsTaillePhotoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _poidsController = TextEditingController();
  final TextEditingController _tailleController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poids, Taille et Photos'),
        backgroundColor: Color(0xFF6200EE), // Couleur violette pour la barre
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Champ de saisie du poids
              TextFormField(
                controller: _poidsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Poids (kg)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un poids';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Champ de saisie de la taille
              TextFormField(
                controller: _tailleController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Taille (cm)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une taille';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Section pour sélectionner des photos
              Text(
                'Sélectionnez deux photos :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8.0),

              // Affichage des images sélectionnées
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImagePicker(0),
                  _buildImagePicker(1),
                ],
              ),
              SizedBox(height: 16.0),

              // Bouton de validation du formulaire
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Valider et soumettre les données
                    print('Poids: ${_poidsController.text}, Taille: ${_tailleController.text}');
                    if (_selectedImages[0] != null && _selectedImages[1] != null) {
                      print('Images sélectionnées : $_selectedImages');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Veuillez sélectionner deux images.')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom( // Couleur violette du bouton
                ),
                child: Text('Soumettre'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour sélectionner et afficher une image
  Widget _buildImagePicker(int index) {
    return GestureDetector(
      onTap: () {
        _showImageSourceDialog(index);
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: _selectedImages[index] != null
            ? Image.file(
          _selectedImages[index]!,
          fit: BoxFit.cover,
        )
            : Icon(Icons.camera_alt, color: Colors.grey),
      ),
    );
  }

  // Dialog pour sélectionner l'image via la galerie ou la caméra
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
