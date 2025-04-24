import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/client.dart';
import '../database/db_helper.dart';

class EditCarPage extends StatefulWidget {
  final Car car;

  const EditCarPage({Key? key, required this.car}) : super(key: key);

  @override
  State<EditCarPage> createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  final _formKey = GlobalKey<FormState>();

  final _plaqueController = TextEditingController();
  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();

  List<Client> _clients = [];
  Client? _selectedClient;
  String? _selectedCategorie;
  String? _selectedEtat;

  final Map<String, List<String>> etatsParCategorie = {
    'Achat': ['Devis en cours', 'En attente de retour client', 'En cours', 'Vendu'],
    'Réparation': ['Devis en cours', 'En attente de retour client', 'En cours', 'Fini'],
  };

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    final clients = await DBHelper.instance.getAllClients();
    final carClient = clients.firstWhere((c) => c.id == widget.car.clientId);
    setState(() {
      _clients = clients;
      _selectedClient = carClient;
      _plaqueController.text = widget.car.plaque;
      _marqueController.text = widget.car.marque;
      _modeleController.text = widget.car.modele;
      _selectedEtat = widget.car.etat;
      _selectedCategorie = etatsParCategorie.entries
          .firstWhere((entry) => entry.value.contains(widget.car.etat), orElse: () => MapEntry('', []))
          .key;
    });
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate() && _selectedClient != null) {
      final updatedCar = Car(
        id: widget.car.id,
        plaque: _plaqueController.text,
        marque: _marqueController.text,
        modele: _modeleController.text,
        etat: _selectedEtat ?? '',
        clientId: _selectedClient!.id,
        lastModified: DateTime.now().toIso8601String(),
        isSynced: false,
      );
      await DBHelper.instance.updateCar(updatedCar);
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  Future<void> _deleteCar() async {
    final updatedCar = Car(
      id: widget.car.id,
      plaque: widget.car.plaque,
      marque: widget.car.marque,
      modele: widget.car.modele,
      etat: widget.car.etat,
      clientId: widget.car.clientId,
      lastModified: DateTime.now().toIso8601String(),
      isSynced: false,
    );
    await DBHelper.instance.updateCar(updatedCar);
    if (!mounted) return;
    Navigator.pop(context, {'deleted': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier une voiture'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Supprimer la voiture ?'),
                  content: const Text('Cette opération marquera la voiture comme supprimée.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirmer')),
                  ],
                ),
              );
              if (confirmed == true) {
                await _deleteCar();
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _plaqueController,
                decoration: const InputDecoration(labelText: "Plaque d'immatriculation"),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _marqueController,
                decoration: const InputDecoration(labelText: 'Marque'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _modeleController,
                decoration: const InputDecoration(labelText: 'Modèle'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Catégorie'),
                value: _selectedCategorie,
                items: etatsParCategorie.keys
                    .map((cat) => DropdownMenuItem<String>(
                  value: cat,
                  child: Text(cat),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategorie = value;
                    _selectedEtat = null;
                  });
                },
                validator: (value) => value == null ? 'Sélectionnez une catégorie' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'État'),
                value: _selectedEtat,
                items: (_selectedCategorie != null ? etatsParCategorie[_selectedCategorie]! : [])
                    .map((etat) => DropdownMenuItem<String>(
                  value: etat,
                  child: Text(etat),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedEtat = value),
                validator: (value) => value == null ? 'Sélectionnez un état' : null,
              ),
              DropdownButtonFormField<Client>(
                decoration: const InputDecoration(labelText: 'Client associé'),
                value: _selectedClient,
                items: _clients.map((client) {
                  return DropdownMenuItem<Client>(
                    value: client,
                    child: Text('${client.prenom} ${client.nom}'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedClient = value),
                validator: (value) => value == null ? 'Sélectionnez un client' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Enregistrer les modifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}