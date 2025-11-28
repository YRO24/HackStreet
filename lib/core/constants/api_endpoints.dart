class ApiEndpoints {
  // Offline mode - these endpoints are now mocked
  static const String baseUrl = 'offline://mock-api';
  static const String analyzeCredit = '/mock/credit/analyze';
  static const String explainScore = '/mock/explain/score';
  
  // Note: In offline mode, all API calls return mock data
  // No actual network requests are made
}
