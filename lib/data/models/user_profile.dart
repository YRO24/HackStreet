class UserProfile {
  final String name;
  final double income;
  final double expenses;
  final String goal;

  UserProfile({
    required this.name,
    required this.income,
    required this.expenses,
    required this.goal,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'income': income,
      'expenses': expenses,
      'goal': goal,
    };
  }
}
