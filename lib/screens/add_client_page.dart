import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/client.dart';
import '../database/db_helper.dart';

class AddClientPage extends StatefulWidget {
  const AddClientPage({super.key});

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _adresseController = TextEditingController();

  Future<void> _saveClient() async {
    if (_formKey.currentState!.validate()) {
      final db = DBHelper.instance;
      final exists = await db.isPhoneOrEmailTaken(
        _telephoneController.text,
        _emailController.text,
      );
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Téléphone ou e-mail déjà utilisé.')),
        );
        return;
      }
      final client = Client(
        id: const Uuid().v4(),
        nom: _nomController.text,
        prenom: _prenomController.text,
        telephone: _telephoneController.text,
        email: _emailController.text,
        adresse: _adresseController.text,
        lastModified: DateTime.now().toIso8601String(),
      );
      await db.insertClient(client);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un client')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _telephoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _adresseController,
                decoration: const InputDecoration(labelText: 'Adresse (optionnel)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveClient,
                child: const Text('Enregistrer'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
