import 'package:feelwell_essentials/pages/Intro.dart';
import 'package:feelwell_essentials/pages/Menu.dart';
import 'package:feelwell_essentials/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './models/pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StorageService storageService = StorageService();
  storageService.getDatabase;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.green,
        ),
      ),
      home: const Scaffold(
        body: Center(child: HomePage()),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Pages currentPage = Pages.intro;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        currentPage = Pages.menu;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _currentPage(currentPage);
  }
}

Widget _currentPage(Pages page) {
  switch (page) {
    case Pages.menu:
      return const Menu();
    default:
      return const Intro();
  }
}
