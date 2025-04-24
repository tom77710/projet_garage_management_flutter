import 'package:flutter/material.dart';
import '../services/firebase_sync_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _syncAutomatically();
  }

  Future<void> _syncAutomatically() async {
    await FirebaseSyncService().syncAll();
    // Tu peux aussi logger si besoin : print('Sync auto terminée');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(220),
        child: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: true,
          flexibleSpace: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    height: 100,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gestion de garage automobile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/ajouter'),
            child: _buildTile(Icons.directions_car, "Ajouter une voiture"),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/liste'),
            child: _buildTile(Icons.list, "Liste des voitures"),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/ajout_client'),
            child: _buildTile(Icons.person_add, "Ajout client"),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/liste_clients'),
            child: _buildTile(Icons.people, "Liste des clients"),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/ajout_employe'),
            child: _buildTile(Icons.person_add_alt, "Ajout employé"),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/liste_employes'),
            child: _buildTile(Icons.people_alt, "Liste des employés"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseSyncService().syncAll();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Synchronisation terminée')),
          );
        },
        child: const Icon(Icons.sync),
      ),
    );
  }

  Widget _buildTile(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 10),
          Text(label),
        ],
      ),
    );
  }
}
