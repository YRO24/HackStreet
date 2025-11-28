import 'package:equatable/equatable.dart';
import '../../data/models/user_profile.dart';

abstract class CreditEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCreditScore extends CreditEvent {
  final UserProfile userProfile;
  FetchCreditScore(this.userProfile);

  @override
  List<Object> get props => [userProfile];
}
