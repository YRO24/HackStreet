// Data models for different dashboard types
enum DashboardType {
  general,
  insurance,
  investment,
  credit,
}

// Base class for all dashboard data
abstract class DashboardData {
  final DashboardType type;
  final String title;
  final String description;
  
  const DashboardData({
    required this.type,
    required this.title,
    required this.description,
  });
}

// General Dashboard Data
class GeneralDashboardData extends DashboardData {
  final double totalIncome;
  final double totalExpenses;
  final double savings;
  final List<IncomeSource> incomeSources;
  final List<ExpenseCategory> expenseCategories;
  final List<MonthlyData> monthlyData;
  
  const GeneralDashboardData({
    required this.totalIncome,
    required this.totalExpenses,
    required this.savings,
    required this.incomeSources,
    required this.expenseCategories,
    required this.monthlyData,
  }) : super(
    type: DashboardType.general,
    title: 'General Dashboard',
    description: 'Complete overview of your finances',
  );
}

class IncomeSource {
  final String name;
  final double amount;
  final String category;
  
  const IncomeSource({
    required this.name,
    required this.amount,
    required this.category,
  });
}

class ExpenseCategory {
  final String name;
  final double amount;
  final String icon;
  final double percentage;
  
  const ExpenseCategory({
    required this.name,
    required this.amount,
    required this.icon,
    required this.percentage,
  });
}

class MonthlyData {
  final String month;
  final double income;
  final double expenses;
  
  const MonthlyData({
    required this.month,
    required this.income,
    required this.expenses,
  });
}

// Insurance Dashboard Data
class InsuranceDashboardData extends DashboardData {
  final List<InsurancePolicy> activePolicies;
  final double totalCoverage;
  final double monthlyPremiums;
  final List<InsuranceClaim> recentClaims;
  final List<InsuranceRecommendation> recommendations;
  
  const InsuranceDashboardData({
    required this.activePolicies,
    required this.totalCoverage,
    required this.monthlyPremiums,
    required this.recentClaims,
    required this.recommendations,
  }) : super(
    type: DashboardType.insurance,
    title: 'Insurance Dashboard',
    description: 'Manage your insurance policies and claims',
  );
}

class InsurancePolicy {
  final String name;
  final String type;
  final double premium;
  final double coverage;
  final DateTime expiryDate;
  final String status;
  
  const InsurancePolicy({
    required this.name,
    required this.type,
    required this.premium,
    required this.coverage,
    required this.expiryDate,
    required this.status,
  });
}

class InsuranceClaim {
  final String id;
  final String policyName;
  final double amount;
  final String status;
  final DateTime dateSubmitted;
  
  const InsuranceClaim({
    required this.id,
    required this.policyName,
    required this.amount,
    required this.status,
    required this.dateSubmitted,
  });
}

class InsuranceRecommendation {
  final String title;
  final String description;
  final String priority;
  
  const InsuranceRecommendation({
    required this.title,
    required this.description,
    required this.priority,
  });
}

// Investment Dashboard Data
class InvestmentDashboardData extends DashboardData {
  final List<Investment> investments;
  final double totalPortfolioValue;
  final double totalGainLoss;
  final double gainLossPercentage;
  final List<InvestmentCategory> categories;
  final List<PerformanceData> performanceHistory;
  
  const InvestmentDashboardData({
    required this.investments,
    required this.totalPortfolioValue,
    required this.totalGainLoss,
    required this.gainLossPercentage,
    required this.categories,
    required this.performanceHistory,
  }) : super(
    type: DashboardType.investment,
    title: 'Investment Dashboard',
    description: 'Track your investment portfolio performance',
  );
}

class Investment {
  final String name;
  final String symbol;
  final double currentValue;
  final double purchasePrice;
  final int quantity;
  final String type;
  final double changePercent;
  
  const Investment({
    required this.name,
    required this.symbol,
    required this.currentValue,
    required this.purchasePrice,
    required this.quantity,
    required this.type,
    required this.changePercent,
  });
}

class InvestmentCategory {
  final String name;
  final double value;
  final double percentage;
  final String riskLevel;
  
  const InvestmentCategory({
    required this.name,
    required this.value,
    required this.percentage,
    required this.riskLevel,
  });
}

class PerformanceData {
  final DateTime date;
  final double value;
  
  const PerformanceData({
    required this.date,
    required this.value,
  });
}

// Credit Dashboard Data
class CreditDashboardData extends DashboardData {
  final int creditScore;
  final List<CreditAccount> creditAccounts;
  final double totalDebt;
  final double availableCredit;
  final double creditUtilization;
  final List<PaymentHistory> paymentHistory;
  final List<CreditRecommendation> recommendations;
  
  const CreditDashboardData({
    required this.creditScore,
    required this.creditAccounts,
    required this.totalDebt,
    required this.availableCredit,
    required this.creditUtilization,
    required this.paymentHistory,
    required this.recommendations,
  }) : super(
    type: DashboardType.credit,
    title: 'Credit Dashboard',
    description: 'Monitor your credit health and debt management',
  );
}

class CreditAccount {
  final String name;
  final String type;
  final double balance;
  final double limit;
  final double interestRate;
  final DateTime nextPaymentDate;
  final double minimumPayment;
  
  const CreditAccount({
    required this.name,
    required this.type,
    required this.balance,
    required this.limit,
    required this.interestRate,
    required this.nextPaymentDate,
    required this.minimumPayment,
  });
}

class PaymentHistory {
  final DateTime date;
  final String account;
  final double amount;
  final String status;
  
  const PaymentHistory({
    required this.date,
    required this.account,
    required this.amount,
    required this.status,
  });
}

class CreditRecommendation {
  final String title;
  final String description;
  final String impact;
  final String urgency;
  
  const CreditRecommendation({
    required this.title,
    required this.description,
    required this.impact,
    required this.urgency,
  });
}