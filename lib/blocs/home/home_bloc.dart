import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/services.dart';
import '../../models/models.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WaterService _waterService;
  final SettingsService _settingsService;
  final MeditationService _meditationService;
  final ExerciseService _exerciseService;

  HomeBloc(
    WaterService waterService,
    SettingsService settingsService,
    ExerciseService exerciseService,
    MeditationService meditationService,
  )   : _waterService = waterService,
        _settingsService = settingsService,
        _exerciseService = exerciseService,
        _meditationService = meditationService,
        super(HomeInitial()) {
    on<HomeShowPage>(_mapHomePage);
    on<HomeShowPageBack>(_mapHomePageBack);
    on<HomeShowSplash>(_mapHomeSplash);
    on<HomeShowLoading>(_mapHomeLoading);
    on<HomeShowExercise>(_mapHomeExercise);
    on<HomeShowFasting>(_mapHomeFasting);
    on<HomeShowWater>(_mapHomeWater);
    on<HomeShowMeditation>(_mapHomeMeditation);
    on<HomeShowSettings>(_mapHomeSettings);
  }

  void _mapHomePage(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeSplash());
    await Future.delayed(const Duration(seconds: 2));

    try {
      SettingsModel? settingsData = await _settingsService.initSettings();
      WaterModel? waterData = await _waterService.initWaterRecord();
      ExerciseModel? exerciseModel = await _exerciseService.initExercise();
      MeditationModel? meditationModel =
          await _meditationService.initMeditation();

      if (settingsData is SettingsModel &&
          waterData is WaterModel &&
          exerciseModel is ExerciseModel &&
          meditationModel is MeditationModel) {
        emit(HomePage());
      } else {
        emit(HomeError());
      }
    } catch (e) {
      print(e.toString());
      emit(HomeError());
    }
  }

  void _mapHomePageBack(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomePage());
  }

  void _mapHomeLoading(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
  }

  void _mapHomeSplash(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeSplash());
  }

  void _mapHomeExercise(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      ExerciseModel? exerciseData = await _exerciseService.getExercise();
      SettingsModel? settingsModel = await _settingsService.getSettings();

      if (exerciseData is ExerciseModel && settingsModel is SettingsModel) {
        emit(HomeExercise(exerciseData: exerciseData));
      } else {
        emit(HomeError());
      }
    } catch (e) {
      print(e.toString());
      emit(HomeError());
    }
  }

  void _mapHomeFasting(HomeEvent event, Emitter<HomeState> emit) async {
    try {
      SettingsModel? settingsData = await _settingsService.initSettings();

      if (settingsData is SettingsModel) {
        FastingModel fastingData = FastingModel.fromIntegers(
          startHour: settingsData.fastingStartHour,
          startMinutes: settingsData.fastingStartMinutes,
          duration: settingsData.fastingLength,
        );

        emit(HomeFasting(fastingData: fastingData));
      } else {
        emit(HomeError());
      }
    } catch (e) {
      print(e.toString());
      emit(HomeError());
    }
  }

  void _mapHomeWater(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      WaterModel? waterData = await _waterService.getWater();
      SettingsModel? settingsModel = await _settingsService.getSettings();

      if (waterData is WaterModel && settingsModel is SettingsModel) {
        emit(HomeWater(water: waterData, glassSize: settingsModel.glassSize));
      } else {
        emit(HomeError());
      }
    } catch (e) {
      print(e.toString());
      emit(HomeError());
    }
  }

  void _mapHomeMeditation(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      MeditationModel? meditationData =
          await _meditationService.getMeditation();
      SettingsModel? settingsModel = await _settingsService.getSettings();

      if (meditationData is MeditationModel && settingsModel is SettingsModel) {
        emit(HomeMeditation(meditationData: meditationData));
      } else {
        emit(HomeError());
      }
    } catch (e) {
      print(e.toString());
      emit(HomeError());
    }
  }

  void _mapHomeSettings(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      SettingsModel? settingsData = await _settingsService.getSettings();

      if (settingsData is SettingsModel) {
        emit(HomeSettings(settings: settingsData));
      } else {
        emit(HomeError());
      }
    } catch (e) {
      print(e.toString());
      emit(HomeError());
    }
  }
}
