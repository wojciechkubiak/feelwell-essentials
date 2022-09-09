import 'package:feelwell_essentials/blocs/home/home_bloc.dart';
import 'package:feelwell_essentials/pages/Intro.dart';
import 'package:feelwell_essentials/pages/Menu.dart';
import 'package:feelwell_essentials/pages/exercise.dart';
import 'package:feelwell_essentials/pages/fasting.dart';
import 'package:feelwell_essentials/pages/meditation.dart';
import 'package:feelwell_essentials/pages/settings.dart';
import 'package:feelwell_essentials/pages/water.dart';
import 'package:feelwell_essentials/services/settings.dart';
import 'package:feelwell_essentials/services/storage.dart';
import 'package:feelwell_essentials/services/water.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        extendBody: true,
        body: Center(child: MyHomePage()),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Pages currentPage = Pages.intro;

  Widget _repositoryProvider() {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SettingsService>(
          create: (context) {
            return SettingsService();
          },
        ),
        RepositoryProvider<WaterService>(
          create: (context) {
            return WaterService();
          },
        ),
      ],
      child: _multiBlocProvider(),
    );
  }

  Widget _multiBlocProvider() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) {
            final settingsService =
                RepositoryProvider.of<SettingsService>(context);
            final waterService = RepositoryProvider.of<WaterService>(context);

            return HomeBloc(
              waterService,
              settingsService,
            )..add(HomeShowPage());
          },
        ),
      ],
      child: _blocBuilder(),
    );
  }

  Widget _blocBuilder() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        print(state);
        if (state is HomePage) {
          return const Menu();
        }
        if (state is HomeLoading) {
          return const Intro();
        }
        if (state is HomeExercise) {
          return const Exercise();
        }
        if (state is HomeFasting) {
          return const Fasting();
        }
        if (state is HomeWater) {
          return Water(
            water: state.water,
          );
        }
        if (state is HomeMeditation) {
          return const Meditation();
        }
        if (state is HomeSettings) {
          return Settings(
            settings: state.settings,
          );
        }

        return const Intro();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _repositoryProvider();
  }
}
