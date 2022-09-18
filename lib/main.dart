import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import './blocs/home/home_bloc.dart';
import './config/color.dart';
import './pages/pages.dart';
import './services/services.dart';
import './models/models.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  StorageService storageService = StorageService();
  storageService.getDatabase;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('pl', 'PL'), Locale('en', 'US')],
      fallbackLocale: const Locale('pl', 'PL'),
      path: 'assets/lang',
      child: const MyApp(),
    ),
  );
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
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
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
        RepositoryProvider<ExerciseService>(
          create: (context) {
            return ExerciseService();
          },
        ),
        RepositoryProvider<MeditationService>(
          create: (context) {
            return MeditationService();
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
            final exerciseService =
                RepositoryProvider.of<ExerciseService>(context);
            final meditationService =
                RepositoryProvider.of<MeditationService>(context);

            return HomeBloc(
              waterService,
              settingsService,
              exerciseService,
              meditationService,
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
          return Exercise(
            exerciseData: state.exerciseData,
          );
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
          return Meditation(
            meditationData: state.meditationData,
          );
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
