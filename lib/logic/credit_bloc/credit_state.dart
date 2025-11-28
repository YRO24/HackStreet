import 'package:equatable/equatable.dart';
import '../../data/models/credit_analysis.dart';

abstract class CreditState extends Equatable {
  @override
  List<Object> get props => [];
}

class CreditInitial extends CreditState {}
class CreditLoading extends CreditState {}
class CreditLoaded extends CreditState {
  final CreditAnalysis analysis;
  CreditLoaded(this.analysis);

  @override
  List<Object> get props => [analysis];
}
class CreditError extends CreditState {
  final String message;
  CreditError(this.message);

  @override
  List<Object> get props => [message];
}
