import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/client.dart';
import '../models/car.dart';
import '../models/employe.dart';

class DBHelper {

  Future<int> updateCar(Car car) async {
    final db = await database;
    return await db.update(
      'cars',
      car.toMap(),
      where: 'id = ?',
      whereArgs: [car.id],
    );
  }

  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<void> initDB() async {
    await database;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('garage.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clients (
        id TEXT PRIMARY KEY,
        nom TEXT,
        prenom TEXT,
        telephone TEXT,
        email TEXT,
        adresse TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cars (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plaque TEXT,
        marque TEXT,
        modele TEXT,
        etat TEXT,
        clientId TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE employes (
        id TEXT PRIMARY KEY,
        nom TEXT,
        prenom TEXT,
        role TEXT
      )
    ''');
  }

  // ----------- Clients -----------
  Future<List<Client>> getAllClients() async {
    final db = await database;
    final result = await db.query('clients');
    return result.map((map) => Client.fromMap(map)).toList();
  }

  Future<Client?> getClientById(String id) async {
    final db = await database;
    final result = await db.query('clients', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Client.fromMap(result.first);
    }
    return null;
  }

  Future<bool> isPhoneOrEmailTaken(String phone, String email) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT * FROM clients WHERE telephone = ? OR email = ?',
      [phone, email],
    );
    return result.isNotEmpty;
  }

  Future<void> insertClient(Client client) async {
    final db = await database;
    await db.insert('clients', client.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateClient(Client client) async {
    final db = await database;
    return await db.update(
      'clients',
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> deleteClient(String id) async {
    final db = await database;
    return await db.delete('clients', where: 'id = ?', whereArgs: [id]);
  }

  // ----------- Voitures -----------
  Future<void> insertCar(Car car) async {
    final db = await database;
    await db.insert('cars', car.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Car>> getAllCars() async {
    final db = await database;
    final result = await db.query('cars');
    return result.map((map) => Car.fromMap(map)).toList();
  }

  Future<List<Car>> getCarsByClientId(String clientId) async {
    final db = await database;
    final result = await db.query('cars', where: 'clientId = ?', whereArgs: [clientId]);
    return result.map((map) => Car.fromMap(map)).toList();
  }

  // ----------- Employés -----------
  Future<void> insertEmploye(Employe employe) async {
    final db = await database;
    print("Insertion dans SQLite : ${employe.toMap()}");
    await db.insert('employes', employe.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Employe>> getAllEmployes() async {
    final db = await database;
    final result = await db.query('employes');
    return result.map((map) => Employe.fromMap(map)).toList();
  }

  Future<int> updateEmploye(Employe employe) async {
    final db = await database;
    return await db.update(
      'employes',
      employe.toMap(),
      where: 'id = ?',
      whereArgs: [employe.id],
    );
  }

  Future<int> deleteEmploye(String id) async {
    final db = await database;
    return await db.delete('employes', where: 'id = ?', whereArgs: [id]);
  }
}
