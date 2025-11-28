import '../models/user_profile.dart';
import '../models/credit_analysis.dart';
import '../sources/api_service.dart';

class CreditRepository {
  final ApiService apiService;
  CreditRepository(this.apiService);

  Future<CreditAnalysis> getCreditAnalysis(UserProfile profile) async {
    // Use mock endpoint - the actual endpoint doesn't matter in offline mode
    final response = await apiService.post('/mock/analyze-credit', profile.toJson());
    return CreditAnalysis.fromJson(response);
  }
}
