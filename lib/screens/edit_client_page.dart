
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/client.dart';

class EditClientPage extends StatefulWidget {
  final Client client;

  const EditClientPage({super.key, required this.client});

  @override
  State<EditClientPage> createState() => _EditClientPageState();
}

class _EditClientPageState extends State<EditClientPage> {
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _telephoneController;
  late TextEditingController _emailController;
  late TextEditingController _adresseController;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.client.nom);
    _prenomController = TextEditingController(text: widget.client.prenom);
    _telephoneController = TextEditingController(text: widget.client.telephone);
    _emailController = TextEditingController(text: widget.client.email);
    _adresseController = TextEditingController(text: widget.client.adresse);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final updatedClient = Client(
      id: widget.client.id,
      nom: _nomController.text,
      prenom: _prenomController.text,
      telephone: _telephoneController.text,
      email: _emailController.text,
      adresse: _adresseController.text,
      lastModified: DateTime.now().toIso8601String(),
    );
    await DBHelper.instance.updateClient(updatedClient);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le client')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _prenomController, decoration: const InputDecoration(labelText: 'Prénom')),
            TextField(controller: _nomController, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: _telephoneController, decoration: const InputDecoration(labelText: 'Téléphone')),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _adresseController, decoration: const InputDecoration(labelText: 'Adresse')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
}
