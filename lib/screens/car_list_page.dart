import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/client.dart';
import '../database/db_helper.dart';
import 'edit_car_page.dart';

class CarListPage extends StatefulWidget {
  const CarListPage({super.key});

  @override
  State<CarListPage> createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  List<Car> _cars = [];
  Map<String, Client> _clients = {};
  List<Car> _filteredCars = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCars();
    _searchController.addListener(_filterCars);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCars() async {
    final cars = await DBHelper.instance.getAllCars();
    final clients = await DBHelper.instance.getAllClients();
    setState(() {
      _cars = cars;
      _clients = {for (var c in clients) c.id: c};
      _filteredCars = cars;
    });
  }

  void _filterCars() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCars = _cars.where((car) {
        final client = _clients[car.clientId];
        final fullName = client != null ? '${client.prenom} ${client.nom}' : '';
        return car.marque.toLowerCase().contains(query) ||
            car.modele.toLowerCase().contains(query) ||
            car.plaque.toLowerCase().contains(query) ||
            fullName.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _markCarAsDeleted(Car car) async {
    final updatedCar = Car(
      id: car.id,
      plaque: car.plaque,
      marque: car.marque,
      modele: car.modele,
      etat: car.etat,
      clientId: car.clientId,
      isSynced: false,
      lastModified: DateTime.now().toIso8601String(),
    );
    await DBHelper.instance.updateCar(updatedCar);
    _loadCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des voitures')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Rechercher...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredCars.isEmpty
                ? const Center(child: Text("Aucune voiture trouvée."))
                : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _filteredCars.length,
              itemBuilder: (context, index) {
                final car = _filteredCars[index];
                final client = _clients[car.clientId];

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${car.marque} ${car.modele}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditCarPage(car: car),
                                    ),
                                  );
                                  if (result == true) _loadCars();
                                } else if (value == 'delete') {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Supprimer cette voiture ?'),
                                      content: const Text('Cette opération marquera la voiture comme supprimée.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Annuler')),
                                        TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Confirmer')),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true) {
                                    await _markCarAsDeleted(car);
                                  }
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(value: 'edit', child: Text('Modifier')),
                                const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.directions_car, size: 18),
                            const SizedBox(width: 6),
                            Text('Plaque : ${car.plaque}'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.info, size: 18),
                            const SizedBox(width: 6),
                            Text('État : ${car.etat}'),
                          ],
                        ),
                        if (client != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 18),
                              const SizedBox(width: 6),
                              Text('Propriétaire : ${client.prenom} ${client.nom}'),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
