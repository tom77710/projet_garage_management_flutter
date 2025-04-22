
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/client.dart';
import 'edit_client_page.dart';
import 'client_cars_page.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({super.key});

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  List<Client> _clients = [];
  List<Client> _filteredClients = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadClients();
    _searchController.addListener(_filterClients);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadClients() async {
    final clients = await DBHelper.instance.getAllClients();
    setState(() {
      _clients = clients;
      _filteredClients = clients;
    });
  }

  void _filterClients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredClients = _clients.where((client) {
        return client.nom.toLowerCase().contains(query) ||
               client.prenom.toLowerCase().contains(query) ||
               client.telephone.toLowerCase().contains(query) ||
               client.email.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _confirmDelete(Client client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer ce client ?"),
        content: Text("Êtes-vous sûr de vouloir supprimer \${client.prenom} \${client.nom} ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              await DBHelper.instance.deleteClient(client.id);
              Navigator.pop(context);
              _loadClients();
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des clients')),
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
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _filteredClients.length,
              itemBuilder: (context, index) {
                final client = _filteredClients[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientCarsPage(client: client),
                    ),
                  ),
                  child: Card(
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
                                '${client.prenom} ${client.nom}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditClientPage(client: client),
                                      ),
                                    ).then((value) {
                                      if (value == true) _loadClients();
                                    });
                                  } else if (value == 'delete') {
                                    _confirmDelete(client);
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
                              const Icon(Icons.phone, size: 18),
                              const SizedBox(width: 6),
                              Text(client.telephone),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.email, size: 18),
                              const SizedBox(width: 6),
                              Text(client.email),
                            ],
                          ),
                          if (client.adresse != null && client.adresse!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.home, size: 18),
                                const SizedBox(width: 6),
                                Text(client.adresse!),
                              ],
                            ),
                          ],
                        ],
                      ),
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
