
import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/car.dart';
import '../database/db_helper.dart';

class ClientCarsPage extends StatefulWidget {
  final Client client;

  const ClientCarsPage({super.key, required this.client});

  @override
  State<ClientCarsPage> createState() => _ClientCarsPageState();
}

class _ClientCarsPageState extends State<ClientCarsPage> {
  List<Car> _cars = [];

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final cars = await DBHelper.instance.getCarsByClientId(widget.client.id);
    setState(() {
      _cars = cars;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voitures de ${widget.client.prenom} ${widget.client.nom}'),
      ),
      body: _cars.isEmpty
          ? const Center(child: Text('Aucune voiture enregistrée.'))
          : ListView.builder(
              itemCount: _cars.length,
              itemBuilder: (context, index) {
                final car = _cars[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  child: ListTile(
                    title: Text('${car.marque} ${car.modele}'),
                    subtitle: Text('Plaque: ${car.plaque} - État: ${car.etat}'),
                  ),
                );
              },
            ),
    );
  }
}
