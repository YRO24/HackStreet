import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../core/theme/app_theme.dart';
import '../models/dashboard_data.dart';
import '../models/gamification_models.dart';
import 'chat_screen.dart';
import 'add_transaction_screen.dart';
import 'transaction_history_screen.dart';
import '../presentation/screens/profile_screen.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;
  
  final List<DashboardData> _dashboardData = [
    _getGeneralDashboardData(),
    _getInsuranceDashboardData(),
    _getInvestmentDashboardData(),
    _getCreditDashboardData(),
  ];

  // Gamification data
  late UserProfile _userProfile;
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _initializeGamificationData();
  }

  void _initializeGamificationData() {
    _userProfile = UserProfile(
      userId: 'user_001',
      name: 'Alex Johnson',
      level: 8,
      currentExp: 2450,
      expToNextLevel: 3000,
      achievements: [
        Achievement(
          id: 'first_save',
          title: 'First Saver',
          description: 'Made your first savings transaction',
          icon: '💰',
          expReward: 100,
          isUnlocked: true,
          unlockedDate: DateTime(2024, 10, 15),
        ),
        Achievement(
          id: 'budget_master',
          title: 'Budget Master',
          description: 'Stayed within budget for 3 consecutive months',
          icon: '📊',
          expReward: 500,
          isUnlocked: true,
          unlockedDate: DateTime(2024, 11, 20),
        ),
        Achievement(
          id: 'investment_pro',
          title: 'Investment Pro',
          description: 'Make 10 successful investment decisions',
          icon: '📈',
          expReward: 1000,
          isUnlocked: false,
        ),
      ],
      categoryExp: {
        'Food': 250,
        'Transportation': 180,
        'Entertainment': 120,
        'Investment': 890,
        'Salary': 1200,
      },
      healthScore: FinancialHealthScore(
        overall: 78,
        budgeting: 75,
        saving: 85,
        investing: 80,
        creditManagement: 72,
      ),
    );

    // Initialize with some mock transactions
    _transactions = [
      Transaction(
        id: '1',
        title: 'Salary Deposit',
        description: 'Monthly salary from TechCorp Inc.',
        amount: 5200.00,
        type: TransactionType.income,
        category: 'Salary',
        date: DateTime(2024, 11, 30),
        rating: TransactionRating.good,
        expGained: 150,
        tags: ['recurring', 'essential'],
        portfolioImpact: PortfolioImpact(
          immediateImpact: 5200,
          longTermProjection: 6240,
          impactDescription: 'Stable income source contributing to financial security',
          affectedCategories: ['Income', 'Savings'],
        ),
      ),
      Transaction(
        id: '2',
        title: 'Grocery Shopping',
        description: 'Weekly grocery shopping at Whole Foods',
        amount: 120.50,
        type: TransactionType.expense,
        category: 'Food',
        date: DateTime(2024, 11, 28),
        rating: TransactionRating.okay,
        expGained: 25,
        tags: ['recurring', 'essential'],
        portfolioImpact: PortfolioImpact(
          immediateImpact: -120.50,
          longTermProjection: -96.40,
          impactDescription: 'Necessary expense for daily living',
          affectedCategories: ['Food', 'Budget'],
        ),
      ),
      Transaction(
        id: '3',
        title: 'Stock Investment',
        description: 'Purchased 10 shares of AAPL',
        amount: 1750.00,
        type: TransactionType.expense,
        category: 'Investment',
        date: DateTime(2024, 11, 25),
        rating: TransactionRating.good,
        expGained: 200,
        tags: ['investment', 'planned'],
        portfolioImpact: PortfolioImpact(
          immediateImpact: -1750.00,
          longTermProjection: 2100.00,
          impactDescription: 'Strategic investment in blue-chip stock for long-term growth',
          affectedCategories: ['Investment', 'Portfolio'],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _buildDashboardContent(_dashboardData[_selectedIndex]),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Add Income FAB
          SizedBox(
            width: 56,
            height: 56,
            child: FloatingActionButton(
              heroTag: "income",
              onPressed: () => _showAddTransactionScreen(TransactionType.income),
              backgroundColor: AppColors.success,
              elevation: 4,
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
          ),
          
          // Transaction History FAB (center, larger)
          FloatingActionButton.extended(
            heroTag: "history",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionHistoryScreen(transactions: _transactions),
                ),
              );
            },
            backgroundColor: AppColors.primary,
            elevation: 6,
            label: const Text(
              'History', 
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const Icon(Icons.history, color: Colors.white, size: 20),
          ),
          
          // Add Expense FAB
          SizedBox(
            width: 56,
            height: 56,
            child: FloatingActionButton(
              heroTag: "expense",
              onPressed: () => _showAddTransactionScreen(TransactionType.expense),
              backgroundColor: AppColors.error,
              elevation: 4,
              child: const Icon(Icons.remove, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTransactionScreen(TransactionType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(
          initialType: type,
          onTransactionAdded: (transaction) {
            setState(() {
              _transactions.add(transaction);
              // Update user profile EXP
              _userProfile = UserProfile(
                userId: _userProfile.userId,
                name: _userProfile.name,
                level: ExpSystem.getLevelFromExp(_userProfile.currentExp + transaction.expGained),
                currentExp: (_userProfile.currentExp + transaction.expGained) % 1000,
                expToNextLevel: 1000,
                achievements: _userProfile.achievements,
                categoryExp: {
                  ..._userProfile.categoryExp,
                  transaction.category: (_userProfile.categoryExp[transaction.category] ?? 0) + transaction.expGained,
                },
                healthScore: _userProfile.healthScore,
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(DashboardData data) {
    switch (data.type) {
      case DashboardType.general:
        return _buildGeneralDashboard(data as GeneralDashboardData);
      case DashboardType.insurance:
        return _buildInsuranceDashboard(data as InsuranceDashboardData);
      case DashboardType.investment:
        return _buildInvestmentDashboard(data as InvestmentDashboardData);
      case DashboardType.credit:
        return _buildCreditDashboard(data as CreditDashboardData);
    }
  }

  Widget _buildGeneralDashboard(GeneralDashboardData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(data.title, data.description),
          const SizedBox(height: 24),
          
          // Financial Overview Cards
          FadeInUp(
            child: Row(
              children: [
                Expanded(
                  child: _buildFinancialCard(
                    'Total Income',
                    '\$${data.totalIncome.toStringAsFixed(0)}',
                    Icons.trending_up,
                    AppColors.successGradient,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFinancialCard(
                    'Total Expenses',
                    '\$${data.totalExpenses.toStringAsFixed(0)}',
                    Icons.trending_down,
                    const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: _buildFinancialCard(
              'Savings This Month',
              '\$${data.savings.toStringAsFixed(0)}',
              Icons.savings,
              AppColors.cardGradient,
              fullWidth: true,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Income Sources Section
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: _buildSectionTitle('Income Sources'),
          ),
          
          const SizedBox(height: 12),
          
          ...data.incomeSources.map((source) => FadeInUp(
            delay: Duration(milliseconds: 600 + data.incomeSources.indexOf(source) * 100),
            child: _buildIncomeSourceItem(source),
          )).toList(),
          
          const SizedBox(height: 24),
          
          // Expense Categories
          FadeInUp(
            delay: const Duration(milliseconds: 800),
            child: _buildSectionTitle('Expense Breakdown'),
          ),
          
          const SizedBox(height: 12),
          
          ...data.expenseCategories.map((category) => FadeInUp(
            delay: Duration(milliseconds: 1000 + data.expenseCategories.indexOf(category) * 100),
            child: _buildExpenseCategoryItem(category),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildInsuranceDashboard(InsuranceDashboardData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(data.title, data.description),
          const SizedBox(height: 24),
          
          // Insurance Overview
          FadeInUp(
            child: Row(
              children: [
                Expanded(
                  child: _buildFinancialCard(
                    'Total Coverage',
                    '\$${(data.totalCoverage / 1000).toStringAsFixed(0)}K',
                    Icons.security,
                    AppColors.cardGradient,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFinancialCard(
                    'Monthly Premiums',
                    '\$${data.monthlyPremiums.toStringAsFixed(0)}',
                    Icons.payment,
                    AppColors.successGradient,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Active Policies
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: _buildSectionTitle('Active Policies'),
          ),
          
          const SizedBox(height: 12),
          
          ...data.activePolicies.map((policy) => FadeInUp(
            delay: Duration(milliseconds: 400 + data.activePolicies.indexOf(policy) * 100),
            child: _buildInsurancePolicyItem(policy),
          )).toList(),
          
          const SizedBox(height: 24),
          
          // Recent Claims
          FadeInUp(
            delay: const Duration(milliseconds: 600),
            child: _buildSectionTitle('Recent Claims'),
          ),
          
          const SizedBox(height: 12),
          
          ...data.recentClaims.map((claim) => FadeInUp(
            delay: Duration(milliseconds: 800 + data.recentClaims.indexOf(claim) * 100),
            child: _buildClaimItem(claim),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildInvestmentDashboard(InvestmentDashboardData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(data.title, data.description),
          const SizedBox(height: 24),
          
          // Portfolio Overview
          FadeInUp(
            child: _buildFinancialCard(
              'Portfolio Value',
              '\$${(data.totalPortfolioValue / 1000).toStringAsFixed(1)}K',
              Icons.account_balance_wallet,
              AppColors.cardGradient,
              fullWidth: true,
              subtitle: '${data.gainLossPercentage > 0 ? '+' : ''}'
                '${data.gainLossPercentage.toStringAsFixed(2)}% '
                '(\$${data.totalGainLoss.toStringAsFixed(0)})',
            ),
          ),
          
          const SizedBox(height: 16),
          
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Row(
              children: [
                Expanded(
                  child: _buildFinancialCard(
                    'Total Investments',
                    '${data.investments.length}',
                    Icons.pie_chart,
                    AppColors.successGradient,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFinancialCard(
                    'Gain/Loss',
                    '\$${data.totalGainLoss.toStringAsFixed(0)}',
                    data.totalGainLoss >= 0 ? Icons.trending_up : Icons.trending_down,
                    data.totalGainLoss >= 0 
                        ? AppColors.successGradient
                        : const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Investment Holdings
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: _buildSectionTitle('Investment Holdings'),
          ),
          
          const SizedBox(height: 12),
          
          ...data.investments.map((investment) => FadeInUp(
            delay: Duration(milliseconds: 600 + data.investments.indexOf(investment) * 100),
            child: _buildInvestmentItem(investment),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildCreditDashboard(CreditDashboardData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(data.title, data.description),
          const SizedBox(height: 24),
          
          // Credit Score Card
          FadeInUp(
            child: _buildCreditScoreCard(data.creditScore),
          ),
          
          const SizedBox(height: 16),
          
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Row(
              children: [
                Expanded(
                  child: _buildFinancialCard(
                    'Total Debt',
                    '\$${data.totalDebt.toStringAsFixed(0)}',
                    Icons.credit_card,
                    const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFinancialCard(
                    'Available Credit',
                    '\$${data.availableCredit.toStringAsFixed(0)}',
                    Icons.account_balance,
                    AppColors.successGradient,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Credit Accounts
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: _buildSectionTitle('Credit Accounts'),
          ),
          
          const SizedBox(height: 12),
          
          ...data.creditAccounts.map((account) => FadeInUp(
            delay: Duration(milliseconds: 600 + data.creditAccounts.indexOf(account) * 100),
            child: _buildCreditAccountItem(account),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, String description) {
    return FadeInDown(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User profile and gamification header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // User avatar and level
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.amber, Colors.orange],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_userProfile.level}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'LVL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // User name and EXP progress
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userProfile.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_userProfile.currentExp}/${_userProfile.expToNextLevel} EXP',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // EXP Progress Bar
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: _userProfile.expProgress,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.amber, Colors.yellow],
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Profile and Chat buttons
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.person, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.chat, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    dashboardData: _dashboardData[_selectedIndex],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Dashboard title and description
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard(
    String title,
    String amount,
    IconData icon,
    Gradient gradient, {
    bool fullWidth = false,
    String? subtitle,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCreditScoreCard(int creditScore) {
    Color scoreColor;
    String scoreText;
    
    if (creditScore >= 800) {
      scoreColor = const Color(0xFF10B981);
      scoreText = 'Excellent';
    } else if (creditScore >= 740) {
      scoreColor = const Color(0xFF3B82F6);
      scoreText = 'Very Good';
    } else if (creditScore >= 670) {
      scoreColor = const Color(0xFFF59E0B);
      scoreText = 'Good';
    } else if (creditScore >= 580) {
      scoreColor = const Color(0xFFEF4444);
      scoreText = 'Fair';
    } else {
      scoreColor = const Color(0xFFDC2626);
      scoreText = 'Poor';
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scoreColor.withValues(alpha: 0.8), scoreColor],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Credit Score',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            creditScore.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            scoreText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildIncomeSourceItem(IncomeSource source) {
    return GestureDetector(
      onLongPress: () => _showIncomeQuickView(source),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
        ),
        child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.attach_money,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  source.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  source.category,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${source.amount.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColors.success,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildExpenseCategoryItem(ExpenseCategory category) {
    return GestureDetector(
      onLongPress: () => _showExpenseQuickView(category),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
        ),
        child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              category.icon,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${category.percentage.toStringAsFixed(1)}% of expenses',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${category.amount.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColors.error,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        ),
      ),
    );
  }

  void _showIncomeQuickView(IncomeSource source) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.successGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.success,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.attach_money, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      source.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '\$${source.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      source.category,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Monthly recurring income contributing to your financial stability',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExpenseQuickView(ExpenseCategory category) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.error,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.error.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    category.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '\$${category.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${category.percentage.toStringAsFixed(1)}% of total expenses',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Track this category to optimize your spending patterns',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsurancePolicyItem(InsurancePolicy policy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  policy.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: policy.status == 'Active' 
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  policy.status,
                  style: TextStyle(
                    color: policy.status == 'Active' ? AppColors.success : AppColors.warning,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Coverage: \$${(policy.coverage / 1000).toStringAsFixed(0)}K',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Text(
                'Premium: \$${policy.premium.toStringAsFixed(0)}/month',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClaimItem(InsuranceClaim claim) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  claim.policyName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Claim ID: ${claim.id}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${claim.amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: claim.status == 'Approved'
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  claim.status,
                  style: TextStyle(
                    color: claim.status == 'Approved' ? AppColors.success : AppColors.warning,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentItem(Investment investment) {
    final isPositive = investment.changePercent >= 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                investment.symbol.substring(0, 2),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  investment.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${investment.quantity} shares • ${investment.type}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${investment.currentValue.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${isPositive ? '+' : ''}${investment.changePercent.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: isPositive ? AppColors.success : AppColors.error,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreditAccountItem(CreditAccount account) {
    final utilizationPercent = (account.balance / account.limit * 100).clamp(0, 100);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  account.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                account.type,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Balance: \$${account.balance.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'Limit: \$${account.limit.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Utilization: ${utilizationPercent.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: utilizationPercent > 30 ? AppColors.warning : AppColors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'APR: ${account.interestRate.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.dashboard, 'General'),
              _buildNavItem(1, Icons.security, 'Insurance'),
              const SizedBox(width: 80), // Space for FAB
              _buildNavItem(2, Icons.trending_up, 'Investment'),
              _buildNavItem(3, Icons.credit_card, 'Credit'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Mock data generators
  static GeneralDashboardData _getGeneralDashboardData() {
    return const GeneralDashboardData(
      totalIncome: 8500,
      totalExpenses: 6200,
      savings: 2300,
      incomeSources: [
        IncomeSource(name: 'Primary Job', amount: 6500, category: 'Salary'),
        IncomeSource(name: 'Freelance', amount: 1500, category: 'Contract'),
        IncomeSource(name: 'Investments', amount: 500, category: 'Dividends'),
      ],
      expenseCategories: [
        ExpenseCategory(name: 'Housing', amount: 2200, icon: '🏠', percentage: 35.5),
        ExpenseCategory(name: 'Food', amount: 800, icon: '🍽️', percentage: 12.9),
        ExpenseCategory(name: 'Transportation', amount: 600, icon: '🚗', percentage: 9.7),
        ExpenseCategory(name: 'Entertainment', amount: 400, icon: '🎬', percentage: 6.5),
        ExpenseCategory(name: 'Utilities', amount: 300, icon: '⚡', percentage: 4.8),
        ExpenseCategory(name: 'Others', amount: 1900, icon: '📱', percentage: 30.6),
      ],
      monthlyData: [],
    );
  }

  static InsuranceDashboardData _getInsuranceDashboardData() {
    return InsuranceDashboardData(
      totalCoverage: 750000,
      monthlyPremiums: 485,
      activePolicies: [
        InsurancePolicy(
          name: 'Life Insurance Premium',
          type: 'Life',
          premium: 125,
          coverage: 500000,
          expiryDate: DateTime(2025, 12, 31),
          status: 'Active',
        ),
        InsurancePolicy(
          name: 'Auto Insurance',
          type: 'Auto',
          premium: 180,
          coverage: 50000,
          expiryDate: DateTime(2025, 8, 15),
          status: 'Active',
        ),
        InsurancePolicy(
          name: 'Home Insurance',
          type: 'Property',
          premium: 180,
          coverage: 200000,
          expiryDate: DateTime(2025, 10, 1),
          status: 'Active',
        ),
      ],
      recentClaims: [
        InsuranceClaim(
          id: 'CLM-2024-001',
          policyName: 'Auto Insurance',
          amount: 1250,
          status: 'Approved',
          dateSubmitted: DateTime(2024, 11, 15),
        ),
        InsuranceClaim(
          id: 'CLM-2024-002',
          policyName: 'Home Insurance',
          amount: 850,
          status: 'Processing',
          dateSubmitted: DateTime(2024, 11, 28),
        ),
      ],
      recommendations: [],
    );
  }

  static InvestmentDashboardData _getInvestmentDashboardData() {
    return const InvestmentDashboardData(
      totalPortfolioValue: 45750,
      totalGainLoss: 2340,
      gainLossPercentage: 5.38,
      investments: [
        Investment(
          name: 'Apple Inc.',
          symbol: 'AAPL',
          currentValue: 235.67,
          purchasePrice: 220.00,
          quantity: 25,
          type: 'Stock',
          changePercent: 7.12,
        ),
        Investment(
          name: 'Tesla Inc.',
          symbol: 'TSLA',
          currentValue: 342.15,
          purchasePrice: 380.50,
          quantity: 15,
          type: 'Stock',
          changePercent: -10.08,
        ),
        Investment(
          name: 'S&P 500 ETF',
          symbol: 'SPY',
          currentValue: 487.23,
          purchasePrice: 465.80,
          quantity: 40,
          type: 'ETF',
          changePercent: 4.60,
        ),
        Investment(
          name: 'Bitcoin',
          symbol: 'BTC',
          currentValue: 43250.00,
          purchasePrice: 38500.00,
          quantity: 1,
          type: 'Crypto',
          changePercent: 12.34,
        ),
      ],
      categories: [],
      performanceHistory: [],
    );
  }

  static CreditDashboardData _getCreditDashboardData() {
    return CreditDashboardData(
      creditScore: 742,
      totalDebt: 8450,
      availableCredit: 15550,
      creditUtilization: 35.2,
      creditAccounts: [
        CreditAccount(
          name: 'Chase Sapphire Card',
          type: 'Credit Card',
          balance: 2340,
          limit: 8000,
          interestRate: 18.24,
          nextPaymentDate: DateTime(2024, 12, 15),
          minimumPayment: 85,
        ),
        CreditAccount(
          name: 'Capital One Venture',
          type: 'Credit Card',
          balance: 1150,
          limit: 5000,
          interestRate: 21.99,
          nextPaymentDate: DateTime(2024, 12, 18),
          minimumPayment: 45,
        ),
        CreditAccount(
          name: 'Auto Loan',
          type: 'Installment',
          balance: 4960,
          limit: 25000,
          interestRate: 4.75,
          nextPaymentDate: DateTime(2024, 12, 1),
          minimumPayment: 425,
        ),
      ],
      paymentHistory: [],
      recommendations: [],
    );
  }
}