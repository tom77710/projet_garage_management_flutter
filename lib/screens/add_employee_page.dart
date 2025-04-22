import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/employe.dart';
import '../database/db_helper.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  Role? _selectedRole;

  Future<void> _saveEmploye() async {
    if (_formKey.currentState!.validate() && _selectedRole != null) {
      final employe = Employe(
        id: const Uuid().v4(),
        nom: _nomController.text,
        prenom: _prenomController.text,
        role: _selectedRole!,
      );
      print("Employé enregistré : ${employe.nom} ${employe.prenom}, rôle : ${employe.role.name}");
      await DBHelper.instance.insertEmploye(employe);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un employé")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              DropdownButtonFormField<Role>(
                decoration: const InputDecoration(labelText: 'Rôle'),
                value: _selectedRole,
                items: Role.values.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedRole = value),
                validator: (value) => value == null ? 'Sélectionnez un rôle' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEmploye,
                child: const Text('Enregistrer'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
