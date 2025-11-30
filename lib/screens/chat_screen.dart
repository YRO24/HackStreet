import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../core/theme/app_theme.dart';
import '../models/dashboard_data.dart';
import '../data/sources/api_service.dart';

class ChatScreen extends StatefulWidget {
  final DashboardData dashboardData;
  
  const ChatScreen({super.key, required this.dashboardData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    // Add initial greeting message based on dashboard type
    String greeting = _getGreetingMessage();
    _messages.add(ChatMessage(
      text: greeting,
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  String _getGreetingMessage() {
    switch (widget.dashboardData.type) {
      case DashboardType.general:
        return "Hello! I'm your General Finance Assistant. I can help you understand your income, expenses, and savings patterns. What would you like to know about your finances?";
      case DashboardType.insurance:
        return "Hi! I'm your Insurance Advisor. I can help you with policy information, coverage details, and claim assistance. How can I help you with your insurance needs today?";
      case DashboardType.investment:
        return "Welcome! I'm your Investment Analyst. I can provide insights about your portfolio performance, market trends, and investment strategies. What investment questions do you have?";
      case DashboardType.credit:
        return "Hello! I'm your Credit Coach. I can help you understand your credit score, manage debt, and improve your credit health. What credit-related questions can I answer for you?";
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    
    // Simulate AI response after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      String response = _generateResponse(text);
      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
    
    _scrollToBottom();
  }

  String _generateResponse(String userMessage) {
    // Enhanced response system with ML integration
    String message = userMessage.toLowerCase();
    
    // For credit dashboard, use ML model predictions
    if (widget.dashboardData.type == DashboardType.credit) {
      return _generateMLCreditResponse(userMessage);
    }
    
    switch (widget.dashboardData.type) {
      case DashboardType.general:
        if (message.contains('income') || message.contains('salary')) {
          final data = widget.dashboardData as GeneralDashboardData;
          return "Based on your data, your total monthly income is \$${data.totalIncome.toStringAsFixed(0)}. Your primary income source is generating \$${data.incomeSources.first.amount.toStringAsFixed(0)} per month. This represents a healthy income stream!";
        } else if (message.contains('expense') || message.contains('spending')) {
          final data = widget.dashboardData as GeneralDashboardData;
          return "Your monthly expenses total \$${data.totalExpenses.toStringAsFixed(0)}. Your largest expense category is ${data.expenseCategories.first.name} at \$${data.expenseCategories.first.amount.toStringAsFixed(0)} (${data.expenseCategories.first.percentage.toStringAsFixed(1)}% of total expenses).";
        } else if (message.contains('saving') || message.contains('save')) {
          final data = widget.dashboardData as GeneralDashboardData;
          return "Great news! You're saving \$${data.savings.toStringAsFixed(0)} this month, which is ${((data.savings / data.totalIncome) * 100).toStringAsFixed(1)}% of your income. Financial experts recommend saving at least 20% of income.";
        }
        break;
        
      case DashboardType.insurance:
        if (message.contains('coverage') || message.contains('policy')) {
          final data = widget.dashboardData as InsuranceDashboardData;
          return "You have ${data.activePolicies.length} active policies with a total coverage of \$${(data.totalCoverage / 1000).toStringAsFixed(0)}K. Your monthly premiums are \$${data.monthlyPremiums.toStringAsFixed(0)}.";
        } else if (message.contains('claim')) {
          final data = widget.dashboardData as InsuranceDashboardData;
          return "You have ${data.recentClaims.length} recent claims. ${data.recentClaims.where((c) => c.status == 'Approved').length} have been approved and ${data.recentClaims.where((c) => c.status == 'Processing').length} are still processing.";
        }
        break;
        
      case DashboardType.investment:
        if (message.contains('portfolio') || message.contains('performance')) {
          final data = widget.dashboardData as InvestmentDashboardData;
          return "Your portfolio is worth \$${(data.totalPortfolioValue / 1000).toStringAsFixed(1)}K with a ${data.gainLossPercentage >= 0 ? 'gain' : 'loss'} of ${data.gainLossPercentage.toStringAsFixed(2)}% (\$${data.totalGainLoss.toStringAsFixed(0)}). You have ${data.investments.length} different investments.";
        } else if (message.contains('stock') || message.contains('investment')) {
          final data = widget.dashboardData as InvestmentDashboardData;
          var bestPerformer = data.investments.reduce((a, b) => a.changePercent > b.changePercent ? a : b);
          return "Your best performing investment is ${bestPerformer.name} (${bestPerformer.symbol}) with a ${bestPerformer.changePercent.toStringAsFixed(2)}% gain.";
        }
        break;
        
      case DashboardType.credit:
        if (message.contains('credit score') || message.contains('score')) {
          final data = widget.dashboardData as CreditDashboardData;
          String scoreCategory = data.creditScore >= 800 ? 'excellent' : 
                               data.creditScore >= 740 ? 'very good' : 
                               data.creditScore >= 670 ? 'good' : 'fair';
          return "Your credit score is ${data.creditScore}, which is considered $scoreCategory. This score gives you access to competitive interest rates and credit products.";
        } else if (message.contains('debt') || message.contains('balance')) {
          final data = widget.dashboardData as CreditDashboardData;
          return "Your total debt is \$${data.totalDebt.toStringAsFixed(0)} across ${data.creditAccounts.length} accounts. Your credit utilization is ${data.creditUtilization.toStringAsFixed(1)}% - keeping this below 30% is recommended.";
        }
        break;
    }
    
    // Default responses if no specific match
    return "I understand you're asking about ${widget.dashboardData.title.toLowerCase()}. While I have access to your dashboard data, I'd need more specific information to provide detailed insights. Could you ask about a particular aspect of your ${widget.dashboardData.type.name} information?";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.dashboardData.type.name.toUpperCase()} AI Assistant',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Powered by your dashboard data',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return FadeInUp(
                  delay: Duration(milliseconds: index * 100),
                  child: _buildMessageBubble(message),
                );
              },
            ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Ask me about your finances...',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: _sendMessage,
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(_messageController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? AppColors.primary 
                    : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : AppColors.textPrimary,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isUser 
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  String _generateMLCreditResponse(String userMessage) {
    // For credit-related questions, this will integrate with your ML model
    
    // Mock user profile data - in real app, this would come from user's actual data
    final mockProfile = {
      'age': 35,
      'monthly_income': 75000,
      'current_credit_score': 680,
      'total_debt': 25000,
      'employment_years': 8,
      'loan_amount': 200000,
      'loan_tenure_months': 240,
      'existing_loans_count': 2,
      'credit_utilization': 45,
      'payment_history_score': 78,
    };

    // Use async/await version in real implementation
    // For demo, using synchronous mock response
    String message = userMessage.toLowerCase();
    
    if (message.contains('score') || message.contains('credit')) {
      return "Based on my ML analysis of your financial profile, I predict your credit score to be around 680-720. This falls in the 'Good' category. Key factors affecting your score include your debt-to-income ratio and credit utilization. Would you like specific recommendations to improve it?";
    } else if (message.contains('improve') || message.contains('better')) {
      return "To improve your credit score, my model suggests: 1) Reduce your credit utilization below 30% (currently at 45%), 2) Continue making on-time payments, and 3) Consider paying down high-interest debt first. These changes could boost your score by 40-60 points over 6 months.";
    } else if (message.contains('loan') || message.contains('mortgage')) {
      return "With your predicted credit score range of 680-720, you should qualify for decent loan terms. For a \$200k mortgage, you might expect rates around 6.5-7.2%. Improving your score to 740+ could save you approximately \$180/month on payments.";
    } else if (message.contains('debt') || message.contains('pay off')) {
      return "Your current debt-to-income ratio suggests focusing on high-interest debt first. My analysis recommends the avalanche method: pay minimums on all debts, then put extra toward the highest interest rate debt. This could save you \$3,200 in interest over the next 2 years.";
    }
    
    // Generic ML-powered response
    return "I've analyzed your financial profile using my machine learning model. Your overall financial health score is 72/100. The main areas for improvement are credit utilization and debt management. Would you like me to create a personalized action plan?";
  }

  // Future method for real ML integration
  Future<void> _sendMLPoweredMessage(String userMessage) async {
    try {
      // This will call your actual ML model
      final profile = {
        'age': 35,
        'monthly_income': 75000,
        'current_credit_score': 680,
        'total_debt': 25000,
        'employment_years': 8,
        'credit_utilization': 45,
        'payment_history_score': 78,
      };
      
      final response = await _apiService.chatAnalysis(profile, question: userMessage);
      
      setState(() {
        _messages.add(ChatMessage(
          text: response['conversation_response'] ?? 'I analyzed your profile but couldn\'t generate a response.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'I\'m having trouble accessing my ML model right now. Let me give you a general response: ${_generateMLCreditResponse(userMessage)}',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}