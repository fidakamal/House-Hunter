import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:house_hunter/Routes.dart';
import 'package:house_hunter/bottom_navigation.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'House Hunter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'House Hunter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageName currentPage = PageName.map;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Routes(currentPage: currentPage),
      bottomNavigationBar: BottomNavigation(
        currentPage: currentPage,
        onPageChange: (newPage) => {
          setState(() => currentPage = newPage),
        },
      ),
    );
  }
}
