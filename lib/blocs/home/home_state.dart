part of 'home_bloc.dart';

abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomePage extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeSplash extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeError extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeExercise extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeFasting extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeWater extends HomeState {
  final WaterModel water;

  HomeWater({required this.water});

  @override
  List<Object> get props => [water];
}

class HomeMeditation extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeSettings extends HomeState {
  final SettingsModel settings;

  HomeSettings({required this.settings});

  @override
  List<Object> get props => [];
}
