import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client.dart';
import '../models/car.dart';
import '../models/employe.dart';
import '../database/db_helper.dart';

class FirebaseSyncService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> syncAll() async {
    await _syncClients();
    await _syncCars();
    await _syncEmployes();
    await _fetchClientsFromFirebase();
    await _fetchCarsFromFirebase();
    await _fetchEmployesFromFirebase();
  }

  Future<void> _syncClients() async {
    final clients = await DBHelper.instance.getAllClients();
    for (final client in clients.where((c) => !c.isSynced)) {
      await _firestore.collection('clients').doc(client.id).set(client.toMap());
      final updated = Client(
        id: client.id,
        nom: client.nom,
        prenom: client.prenom,
        telephone: client.telephone,
        email: client.email,
        adresse: client.adresse,
        isSynced: true,
        lastModified: client.lastModified,
      );
      await DBHelper.instance.updateClient(updated);
    }
  }

  Future<void> _syncCars() async {
    final cars = await DBHelper.instance.getAllCars();
    for (final car in cars.where((c) => !c.isSynced)) {
      await _firestore.collection('cars').doc(car.id.toString()).set(car.toMap());
      final updated = Car(
        id: car.id,
        plaque: car.plaque,
        marque: car.marque,
        modele: car.modele,
        etat: car.etat,
        clientId: car.clientId,
        isSynced: true,
        lastModified: car.lastModified,
      );
      await DBHelper.instance.updateCar(updated);
    }
  }

  Future<void> _syncEmployes() async {
    final employes = await DBHelper.instance.getAllEmployes();
    for (final emp in employes.where((e) => !e.isSynced)) {
      await _firestore.collection('employes').doc(emp.id).set(emp.toMap());
      final updated = Employe(
        id: emp.id,
        nom: emp.nom,
        prenom: emp.prenom,
        role: emp.role,
        isSynced: true,
        lastModified: emp.lastModified,
      );
      await DBHelper.instance.updateEmploye(updated);
    }
  }

  Future<void> _fetchClientsFromFirebase() async {
    final snapshot = await _firestore.collection('clients').get();
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final client = Client.fromMap(data);
      final local = await DBHelper.instance.getClientById(client.id);
      if (local == null || local.lastModified.compareTo(client.lastModified) < 0) {
        await DBHelper.instance.insertClient(client);
      }
    }
  }

  Future<void> _fetchCarsFromFirebase() async {
    final snapshot = await _firestore.collection('cars').get();
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final car = Car.fromMap(data);
      final localCars = await DBHelper.instance.getAllCars();
      Car? local;
      try {
        local = localCars.firstWhere((c) => c.id == car.id);
      } catch (_) {
        local = null;
      }
      if (local == null || local.lastModified.compareTo(car.lastModified) < 0) {
        await DBHelper.instance.insertCar(car);
      }
    }
  }

  Future<void> _fetchEmployesFromFirebase() async {
    final snapshot = await _firestore.collection('employes').get();
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final emp = Employe.fromMap(data);
      final localEmps = await DBHelper.instance.getAllEmployes();
      Employe? local;
      try {
        local = localEmps.firstWhere((e) => e.id == emp.id);
      } catch (_) {
        local = null;
      }
      if (local == null || local.lastModified.compareTo(emp.lastModified) < 0) {
        await DBHelper.instance.insertEmploye(emp);
      }
    }
  }
}
