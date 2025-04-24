import 'package:flutter/material.dart';
import '../models/employe.dart';
import '../database/db_helper.dart';

class EditEmployeePage extends StatefulWidget {
  final Employe employe;

  const EditEmployeePage({super.key, required this.employe});

  @override
  State<EditEmployeePage> createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  Role? _selectedRole;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.employe.nom);
    _prenomController = TextEditingController(text: widget.employe.prenom);
    _selectedRole = widget.employe.role;
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final updated = Employe(
      id: widget.employe.id,
      nom: _nomController.text,
      prenom: _prenomController.text,
      role: _selectedRole!,
      lastModified: DateTime.now().toIso8601String(),
    );
    await DBHelper.instance.updateEmploye(updated);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier employé')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              controller: _prenomController,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            DropdownButtonFormField<Role>(
              value: _selectedRole,
              items: Role.values.map((role) => DropdownMenuItem(
                value: role,
                child: Text(role.name),
              )).toList(),
              onChanged: (value) => setState(() => _selectedRole = value),
              decoration: const InputDecoration(labelText: 'Rôle'),
            ),
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
