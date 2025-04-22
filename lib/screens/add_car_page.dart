import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/client.dart';
import '../database/db_helper.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({super.key});

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final Map<String, List<String>> etatsParCategorie = {
    'Achat': [
      'Devis en cours',
      'En attente de retour client',
      'En cours',
      'Vendu',
    ],
    'Réparation': [
      'Devis en cours',
      'En attente de retour client',
      'En cours',
      'Fini',
    ],
  };

  String? _selectedCategorie;
  String? _selectedEtat;

  final _formKey = GlobalKey<FormState>();
  final _plaqueController = TextEditingController();
  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();
  // _etatController is not needed since we're using _selectedEtat from dropdown

  List<Client> _clients = [];
  Client? _selectedClient;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    final clients = await DBHelper.instance.getAllClients();
    setState(() {
      _clients = clients;
    });
  }

  Future<void> _saveCar() async {
    if (_formKey.currentState!.validate() && _selectedClient != null) {
      final car = Car(
        plaque: _plaqueController.text,
        marque: _marqueController.text,
        modele: _modeleController.text,
        etat: _selectedEtat ?? '',
        clientId: _selectedClient!.id,
      );
      await DBHelper.instance.insertCar(car);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une voiture')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _plaqueController,
                decoration: const InputDecoration(labelText: 'Plaque d\'immatriculation'),
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
                    .map((categorie) => DropdownMenuItem<String>(
                  value: categorie,
                  child: Text(categorie),
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
                items: (_selectedCategorie != null
                    ? etatsParCategorie[_selectedCategorie]!
                    : [])
                    .map((etat) => DropdownMenuItem<String>(
                  value: etat,
                  child: Text(etat),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEtat = value;
                  });
                },
                validator: (value) => value == null ? 'Sélectionnez un état' : null,
              ),
              DropdownButtonFormField<Client>(
                value: _selectedClient,
                items: _clients.map((client) {
                  return DropdownMenuItem<Client>(
                    value: client,
                    child: Text('${client.prenom} ${client.nom}'),
                  );
                }).toList(),
                onChanged: (client) => setState(() => _selectedClient = client),
                decoration: const InputDecoration(labelText: 'Client associé'),
                validator: (value) => value == null ? 'Sélectionnez un client' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCar,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}