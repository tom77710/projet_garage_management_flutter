import 'package:flutter/material.dart';
import '../models/employe.dart';
import '../database/db_helper.dart';
import 'edit_employee_page.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<Employe> _employes = [];
  List<Employe> _filteredEmployes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEmployes();
    _searchController.addListener(_filterEmployes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEmployes() async {
    final data = await DBHelper.instance.getAllEmployes();
    print("Liste chargée : ${data.length} employés");
    setState(() {
      _employes = data;
      _filteredEmployes = data;
    });
  }

  void _filterEmployes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredEmployes = _employes.where((e) =>
      e.nom.toLowerCase().contains(query) ||
          e.prenom.toLowerCase().contains(query) ||
          e.role.name.toLowerCase().contains(query)
      ).toList();
    });
  }

  void _confirmDelete(Employe employe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer l'employé ?"),
        content: Text("Êtes-vous sûr de vouloir supprimer ${employe.prenom} ${employe.nom} ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
            onPressed: () async {
              await DBHelper.instance.deleteEmploye(employe.id);
              Navigator.pop(context);
              _loadEmployes();
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des employés")),
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
            child: _filteredEmployes.isEmpty
                ? const Center(child: Text("Aucun employé trouvé."))
                : ListView.builder(
              itemCount: _filteredEmployes.length,
              itemBuilder: (context, index) {
                final emp = _filteredEmployes[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${emp.prenom} ${emp.nom}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditEmployeePage(employe: emp),
                                    ),
                                  ).then((value) {
                                    if (value == true) _loadEmployes();
                                  });
                                } else if (value == 'delete') {
                                  _confirmDelete(emp);
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
                            const Icon(Icons.badge, size: 18),
                            const SizedBox(width: 6),
                            Text('Rôle : ${emp.role.name}'),
                          ],
                        ),
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
