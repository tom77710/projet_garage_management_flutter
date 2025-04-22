import 'package:flutter/material.dart';
import 'database/db_helper.dart';
import 'screens/home_page.dart';
import 'screens/add_car_page.dart';
import 'screens/car_list_page.dart';
import 'screens/client_list_page.dart';
import 'screens/add_client_page.dart';
import 'screens/add_employee_page.dart';
import 'screens/employee_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.instance.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Garage Auto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/ajouter': (context) => const AddCarPage(),
        '/liste': (context) => const CarListPage(),
        '/ajout_client': (context) => const AddClientPage(),
        '/liste_clients': (context) => const ClientListPage(),
        '/ajout_employe': (context) => const AddEmployeePage(),
        '/liste_employes': (context) => const EmployeeListPage(),
      },
    );
  }
}
