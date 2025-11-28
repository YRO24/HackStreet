class CreditAnalysis {
  final int score;
  final Map<String, dynamic> breakdown;
  final Map<String, dynamic> plan;

  CreditAnalysis({
    required this.score,
    required this.breakdown,
    required this.plan,
  });

  factory CreditAnalysis.fromJson(Map<String, dynamic> json) {
    return CreditAnalysis(
      score: json['genfi_score'],
      breakdown: json['breakdown'],
      plan: json['plan'],
    );
  }
}
