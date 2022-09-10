import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feelwell_essentials/models/fasting.dart';
import 'package:feelwell_essentials/models/ids.dart';
import 'package:feelwell_essentials/services/settings.dart';
import 'package:feelwell_essentials/services/water.dart';

import '../../models/water.dart';
import '../../models/settings.dart';
import '../../services/water.dart';
import '../../services/settings.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WaterService _waterService;
  final SettingsService _settingsService;

  HomeBloc(
    WaterService waterService,
    SettingsService settingsService,
  )   : _waterService = waterService,
        _settingsService = settingsService,
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

      if (settingsData is SettingsModel && waterData is WaterModel) {
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
    emit(HomeExercise());
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
      int id = Ids.getRecordId();

      WaterModel? waterData = await _waterService.getWater(id: id);
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
    emit(HomeMeditation());
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
