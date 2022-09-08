import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
  }

  void _mapHomePage(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomePage());
  }

  void _mapHomeLoading(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
  }

  void _mapHomeSplash(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeSplash());
  }
}
