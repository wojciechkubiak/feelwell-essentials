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
  final ExerciseModel exerciseData;

  HomeExercise({required this.exerciseData});

  @override
  List<Object> get props => [exerciseData];
}

class HomeFasting extends HomeState {
  final FastingModel fastingData;

  HomeFasting({required this.fastingData});

  @override
  List<Object> get props => [fastingData];
}

class HomeWater extends HomeState {
  final WaterModel water;
  final int glassSize;

  HomeWater({required this.water, required this.glassSize});

  @override
  List<Object> get props => [water, glassSize];
}

class HomeMeditation extends HomeState {
  final MeditationModel meditationData;

  HomeMeditation({required this.meditationData});

  @override
  List<Object> get props => [meditationData];
}

class HomeSettings extends HomeState {
  final SettingsModel settings;

  HomeSettings({required this.settings});

  @override
  List<Object> get props => [];
}
