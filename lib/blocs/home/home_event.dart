part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeShowPage extends HomeEvent {
  @override
  List<Object> get props => [];
}

class HomeShowLoading extends HomeEvent {
  @override
  List<Object> get props => [];
}

class HomeShowSplash extends HomeEvent {
  @override
  List<Object> get props => [];
}
