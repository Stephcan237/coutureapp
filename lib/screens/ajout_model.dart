import 'dart:io';
import 'package:coutureapp/screens/models/MaisonCouture.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AjoutmodelPage extends StatefulWidget {
  final MaisonCouture maisoncouture;
  const AjoutmodelPage({super.key, required this.maisoncouture});

  @override
  State<AjoutmodelPage> createState() => _TransitionPageState();
}

class _TransitionPageState extends State<AjoutmodelPage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<File?> _selectedImages = [null, null]; // Limité à deux images

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
        title: const Text("Ajoutez un modele"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Nom du modèle',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez le nom';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Entrez une description',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez une description';
                  }
                  return null;
                },
                maxLines: 5,
              ),
              const SizedBox(
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
                      : const Icon(Icons.camera_alt, color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      widget.maisoncouture.addModel(
                          _nomController.text,
                          _descriptionController.text,
                          _selectedImages[0]!,
                          context);
                    },
                    child: const Text("Ajouter le modèle")),
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
        title: const Text('Sélectionner une image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Depuis la galerie'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(index, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Prendre une photo'),
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
