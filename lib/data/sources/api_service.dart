import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api'; // Your backend URL
  final bool useMockData;
  
  ApiService({this.useMockData = true}); // Set to false to use real backend

  // Main API call method
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    if (useMockData || endpoint.contains('analyze')) {
      // Use mock data for existing functionality
      await Future.delayed(const Duration(milliseconds: 800));
      return _generateMockCreditAnalysis(body);
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to mock if backend unavailable
      print('Backend unavailable, using mock data: $e');
      return _generateMockCreditAnalysis(body);
    }
  }

  // New method for ML credit prediction
  Future<Map<String, dynamic>> predictCredit(Map<String, dynamic> profile) async {
    if (useMockData) {
      return _generateMockCreditAnalysis(profile);
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/credit/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(profile),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Prediction API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('ML prediction unavailable, using fallback: $e');
      return _generateMockCreditAnalysis(profile);
    }
  }

  // Chat-specific analysis for your ML model
  Future<Map<String, dynamic>> chatAnalysis(Map<String, dynamic> profile, {String question = ''}) async {
    if (useMockData) {
      final analysis = _generateMockCreditAnalysis(profile);
      analysis['conversation_response'] = _generateChatResponse(analysis, question);
      return analysis;
    }
    
    try {
      final requestBody = {
        ...profile,
        'question': question,
      };
      
      final response = await http.post(
        Uri.parse('$baseUrl/credit/chat-analysis'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Chat Analysis Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Chat analysis unavailable, using fallback: $e');
      final analysis = _generateMockCreditAnalysis(profile);
      analysis['conversation_response'] = _generateChatResponse(analysis, question);
      return analysis;
    }
  }

  // Load your Jupyter notebook model
  Future<bool> loadModel(String modelPath) async {
    if (useMockData) {
      print('Mock mode: Model loading simulated');
      return true;
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/credit/load-model'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'model_path': modelPath}),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Model loading failed: $e');
      return false;
    }
  }

  String _generateChatResponse(Map<String, dynamic> analysis, String question) {
    final score = analysis['score'] as int;
    final grade = analysis['grade'] as String;
    
    String response = "Based on your financial profile, I've calculated your credit score to be $score (Grade: $grade). ";
    
    if (question.toLowerCase().contains('improve')) {
      final recommendations = analysis['recommendations'] as List<String>;
      response += "To improve your score, I recommend: ${recommendations.first}";
    } else if (question.toLowerCase().contains('loan')) {
      if (score >= 700) {
        response += "With your current score, you should qualify for competitive loan rates!";
      } else {
        response += "Your score could benefit from improvement before applying for major loans.";
      }
    } else {
      response += "Is there anything specific about your credit profile you'd like me to explain?";
    }
    
    return response;
  }

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'data': 'Mock data response'};
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return {'success': true, 'data': body};
  }

  Map<String, dynamic> _generateMockCreditAnalysis(Map<String, dynamic> userProfile) {
    final income = (userProfile['income'] as num?)?.toDouble() ?? 50000;
    final expenses = (userProfile['expenses'] as num?)?.toDouble() ?? 30000;
    final name = userProfile['name'] as String? ?? 'User';
    final goal = userProfile['goal'] as String? ?? 'Emergency Fund';
    
    final random = Random();
    
    // Calculate credit score based on income-to-expense ratio
    final incomeRatio = income / (expenses + 1); // Avoid division by zero
    int baseScore = 600;
    
    if (incomeRatio > 2.5) baseScore = 750;
    else if (incomeRatio > 2.0) baseScore = 720;
    else if (incomeRatio > 1.5) baseScore = 680;
    else if (incomeRatio > 1.2) baseScore = 650;
    
    final creditScore = (baseScore + random.nextInt(50) - 25).clamp(300, 850);
    
    // Generate factors based on the profile
    final factors = <Map<String, dynamic>>[];
    
    if (incomeRatio > 1.5) {
      factors.add({
        'factor': 'Good Income-to-Expense Ratio',
        'impact': 'positive',
        'description': 'Your expenses are well below your income, showing good financial management.',
      });
    } else if (incomeRatio < 1.1) {
      factors.add({
        'factor': 'High Expense Ratio',
        'impact': 'negative', 
        'description': 'Your expenses are quite high relative to your income. Consider budgeting.',
      });
    }
    
    if (income > 60000) {
      factors.add({
        'factor': 'Stable Income',
        'impact': 'positive',
        'description': 'Your income level indicates financial stability.',
      });
    }
    
    factors.add({
      'factor': 'Financial Goal Set',
      'impact': 'positive',
      'description': 'Having a clear financial goal like "$goal" shows good planning.',
    });
    
    // Generate recommendations
    final recommendations = <String>[];
    
    if (incomeRatio < 1.3) {
      recommendations.add('Consider reducing monthly expenses by 10-15%');
      recommendations.add('Look for additional income sources');
    }
    
    if (goal.toLowerCase().contains('emergency')) {
      recommendations.add('Aim to save 3-6 months of expenses for emergency fund');
    }
    
    recommendations.addAll([
      'Set up automatic savings of ${(income * 0.1).toInt()} per month',
      'Review and optimize your spending categories',
      'Consider investment options for long-term growth',
    ]);
    
    return {
      'score': creditScore,
      'grade': _getGradeFromScore(creditScore),
      'factors': factors,
      'recommendations': recommendations,
      'monthlyIncome': income,
      'monthlyExpenses': expenses,
      'savingsRate': ((income - expenses) / income * 100).clamp(0, 100),
      'riskLevel': _getRiskLevel(creditScore),
      'userName': name,
      'financialGoal': goal,
      'generatedAt': DateTime.now().toIso8601String(),
    };
  }
  
  String _getGradeFromScore(int score) {
    if (score >= 800) return 'A+';
    if (score >= 750) return 'A';
    if (score >= 700) return 'B+';
    if (score >= 650) return 'B';
    if (score >= 600) return 'C+';
    if (score >= 550) return 'C';
    return 'D';
  }
  
  String _getRiskLevel(int score) {
    if (score >= 750) return 'Low';
    if (score >= 650) return 'Medium';
    return 'High';
  }

  void dispose() {
    // No resources to dispose in mock mode
  }
}
