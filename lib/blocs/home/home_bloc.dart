import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    on<HomeShowSplash>(_mapHomeSplash);
    on<HomeShowLoading>(_mapHomeLoading);
    on<HomeShowExercise>(_mapHomeExercise);
    on<HomeShowFasting>(_mapHomeFasting);
    on<HomeShowWater>(_mapHomeWater);
    on<HomeShowMeditation>(_mapHomeMeditation);
    on<HomeShowSettings>(_mapHomeSettings);
  }

  void _mapHomePage(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      SettingsModel? settingsData = await _settingsService.initSettings();

      if (settingsData is SettingsModel) {
        emit(HomePage());
      } else {
        emit(HomeError());
      }

      print(2);
    } catch (e) {
      print(e.toString());
      emit(HomeError());
    }
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
    emit(HomeFasting());
  }

  void _mapHomeWater(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      int id = Ids.getRecordId();

      WaterModel? waterData = await _waterService.getWater(id: id);

      if (waterData is WaterModel) {
        emit(HomeWater(water: waterData));
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
