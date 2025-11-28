import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/credit_repository.dart';
import 'credit_event.dart';
import 'credit_state.dart';

class CreditBloc extends Bloc<CreditEvent, CreditState> {
  final CreditRepository repository;
  CreditBloc(this.repository) : super(CreditInitial()) {
    on<FetchCreditScore>((event, emit) async {
      emit(CreditLoading());
      try {
        // In offline mode, this will use mock data
        final result = await repository.getCreditAnalysis(event.userProfile);
        emit(CreditLoaded(result));
      } catch (e) {
        // Provide fallback error message for offline mode
        final errorMessage = e.toString().contains('connection') 
            ? 'Running in offline mode with sample data'
            : e.toString();
        emit(CreditError(errorMessage));
      }
    });
  }
}
