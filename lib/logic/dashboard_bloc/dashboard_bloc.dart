import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class DashboardEvent {}
class LoadDashboard extends DashboardEvent {}

// States
abstract class DashboardState {}
class DashboardInitial extends DashboardState {}
class DashboardLoaded extends DashboardState {}

// Bloc
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboard>((event, emit) {
      emit(DashboardLoaded());
    });
  }
}
