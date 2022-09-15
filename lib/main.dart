import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './blocs/home/home_bloc.dart';
import './config/color.dart';
import './pages/pages.dart';
import './services/services.dart';
import './models/models.dart';

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
        primarySwatch: customGreen,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
      ),
      home: const Center(child: MyHomePage()),
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
        if (state is HomePage) {
          return const Menu();
        }
        if (state is HomeLoading) {
          return const Loading();
        }
        if (state is HomeExercise) {
          return const Exercise();
        }
        if (state is HomeFasting) {
          return Fasting(fastingData: state.fastingData);
        }
        if (state is HomeWater) {
          return Water(
            water: state.water,
            glassSize: state.glassSize,
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
        if (state is HomeError) {
          return const ErrorPage();
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
