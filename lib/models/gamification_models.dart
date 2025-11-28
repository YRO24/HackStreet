// Gamification models
class UserProfile {
  final String userId;
  final String name;
  final int level;
  final int currentExp;
  final int expToNextLevel;
  final List<Achievement> achievements;
  final Map<String, int> categoryExp;
  final FinancialHealthScore healthScore;
  
  const UserProfile({
    required this.userId,
    required this.name,
    required this.level,
    required this.currentExp,
    required this.expToNextLevel,
    required this.achievements,
    required this.categoryExp,
    required this.healthScore,
  });
  
  double get expProgress => currentExp / expToNextLevel;
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int expReward;
  final bool isUnlocked;
  final DateTime? unlockedDate;
  
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.expReward,
    required this.isUnlocked,
    this.unlockedDate,
  });
}

class FinancialHealthScore {
  final int overall;
  final int budgeting;
  final int saving;
  final int investing;
  final int creditManagement;
  
  const FinancialHealthScore({
    required this.overall,
    required this.budgeting,
    required this.saving,
    required this.investing,
    required this.creditManagement,
  });
}

// Transaction models with detailed information
class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String description;
  final TransactionRating rating;
  final PortfolioImpact portfolioImpact;
  final int expGained;
  final List<String> tags;
  final String? location;
  final String? notes;
  
  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.description,
    required this.rating,
    required this.portfolioImpact,
    required this.expGained,
    required this.tags,
    this.location,
    this.notes,
  });
}

enum TransactionType {
  income,
  expense,
}

enum TransactionRating {
  bad,
  okay,
  good,
}

class PortfolioImpact {
  final double immediateImpact;
  final double longTermProjection;
  final String impactDescription;
  final List<String> affectedCategories;
  
  const PortfolioImpact({
    required this.immediateImpact,
    required this.longTermProjection,
    required this.impactDescription,
    required this.affectedCategories,
  });
}

// EXP system
class ExpSystem {
  static const Map<TransactionRating, int> baseExpRewards = {
    TransactionRating.good: 50,
    TransactionRating.okay: 20,
    TransactionRating.bad: 5,
  };
  
  static const Map<String, double> categoryMultipliers = {
    'Savings': 1.5,
    'Investment': 1.8,
    'Education': 1.6,
    'Health': 1.3,
    'Emergency Fund': 2.0,
    'Debt Payment': 1.4,
    'Entertainment': 0.8,
    'Shopping': 0.7,
    'Food': 1.0,
    'Transportation': 1.0,
  };
  
  static int calculateExp(Transaction transaction) {
    int baseExp = baseExpRewards[transaction.rating] ?? 0;
    double multiplier = categoryMultipliers[transaction.category] ?? 1.0;
    
    // Bonus for larger amounts (up to 2x multiplier)
    double amountMultiplier = 1.0;
    if (transaction.amount > 1000) {
      amountMultiplier = 1.5;
    } else if (transaction.amount > 5000) {
      amountMultiplier = 2.0;
    }
    
    return (baseExp * multiplier * amountMultiplier).round();
  }
  
  static int getExpForLevel(int level) {
    return (level * 100 * (1.2 * level)).round();
  }
  
  static int getLevelFromExp(int totalExp) {
    int level = 1;
    int expNeeded = 0;
    
    while (expNeeded < totalExp) {
      level++;
      expNeeded += getExpForLevel(level);
    }
    
    return level - 1;
  }
}