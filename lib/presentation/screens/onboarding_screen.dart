import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../logic/credit_bloc/credit_bloc.dart';
import '../../logic/credit_bloc/credit_event.dart';
import '../../data/models/user_profile.dart';
import '../../core/theme/app_theme.dart';
import '../../core/navigation/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _incomeController = TextEditingController();
  final _expensesController = TextEditingController();
  final _goalController = TextEditingController();
  
  int _currentStep = 0;
  bool _isLoading = false;
  bool _isFormExpanded = false;

  final List<String> _goals = [
    'Buy a House',
    'Emergency Fund',
    'Retirement Planning',
    'Education Fund',
    'Investment Growth',
    'Debt Payoff',
    'Travel Fund',
    'Other'
  ];

  String? _selectedGoal;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _incomeController.dispose();
    _expensesController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: AppSizes.paddingL),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Progress Indicator
                        FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          child: Container(
                            margin: const EdgeInsets.all(AppSizes.paddingL),
                            padding: const EdgeInsets.all(AppSizes.paddingM),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppSizes.radiusM),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Step ${_currentStep + 1} of 4',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      '${(((_currentStep + 1) / 4) * 100).round()}% Complete',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                LinearProgressIndicator(
                                  value: (_currentStep + 1) / 4,
                                  backgroundColor: AppColors.surfaceVariant,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Stepper
                        Expanded(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: Theme.of(context).colorScheme.copyWith(
                                primary: AppColors.primary,
                              ),
                            ),
                            child: Stepper(
                              currentStep: _currentStep,
                              onStepTapped: (step) {
                                if (step <= _currentStep) {
                                  setState(() => _currentStep = step);
                                }
                              },
                              onStepContinue: () {
                                _handleStepContinue(ControlsDetails(
                                  stepIndex: _currentStep,
                                  currentStep: _currentStep,
                                  onStepContinue: () {
                                    if (_currentStep < 3) {
                                      setState(() => _currentStep++);
                                    }
                                  },
                                ));
                              },
                              controlsBuilder: _buildStepperControls,
                              steps: [
                                _buildPersonalInfoStep(),
                                _buildIncomeStep(),
                                _buildExpensesStep(),
                                _buildGoalsStep(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            vertical: _isFormExpanded ? 20 : 40,
            horizontal: 20,
          ),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(_isFormExpanded ? 8 : 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(_isFormExpanded ? 0.05 : 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(_isFormExpanded ? 0.2 : 0.3), 
                    width: _isFormExpanded ? 1 : 2,
                  ),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  size: _isFormExpanded ? 24 : 48,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: _isFormExpanded ? 8 : AppSizes.paddingM),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: _isFormExpanded ? 24 : 32,
                  fontFamily: 'sans-serif',
                ),
                child: const Text('Welcome to GenFi'),
              ),
              SizedBox(height: _isFormExpanded ? 4 : AppSizes.paddingS),
              if (!_isFormExpanded) ...[
                Text(
                  'Let\'s set up your financial profile in just 4 simple steps',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'sans-serif',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.paddingS),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.white70, size: 16),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Fill in the forms below to continue',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            fontFamily: 'sans-serif',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text(
                  'Step 1 of 4 - Personal Information',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: 'sans-serif',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Step _buildPersonalInfoStep() {
    return Step(
      title: GestureDetector(
        onTap: () {
          if (!_isFormExpanded) {
            setState(() {
              _isFormExpanded = true;
            });
          }
        },
        child: Row(
          children: [
            const Text('Personal Info'),
            if (!_isFormExpanded) ...[
              const SizedBox(width: 8),
              const Icon(Icons.touch_app, size: 16, color: Colors.grey),
            ],
          ],
        ),
      ),
      content: FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tell us about yourself',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Please fill in your basic information below',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingL),
            GestureDetector(
              onTap: () {
                if (!_isFormExpanded) {
                  setState(() {
                    _isFormExpanded = true;
                  });
                  // Show a subtle feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Great! Now fill in your information and click Continue'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isFormExpanded ? 0.15 : 0.08),
                      blurRadius: _isFormExpanded ? 12 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: _isFormExpanded ? AppColors.primary : Colors.grey.withOpacity(0.3),
                    width: _isFormExpanded ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    if (!_isFormExpanded)
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Icon(Icons.touch_app, color: AppColors.primary, size: 28),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '👆 Tap anywhere here to enter your details',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Click to expand the form and enter your details',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 16),
                            ),
                          ],
                        ),
                      ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: _isFormExpanded ? Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              style: const TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                labelText: 'Full Name *',
                                labelStyle: const TextStyle(color: Colors.black54),
                                hintText: 'Enter your full name here',
                                hintStyle: const TextStyle(color: Colors.black38),
                                prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.info.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.info.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Your name helps us personalize your financial experience',
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ) : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
    );
  }

  Step _buildIncomeStep() {
    return Step(
      title: const Text('Monthly Income'),
      content: FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: AppColors.success.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.trending_up, color: AppColors.success),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What\'s your monthly income?',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Include salary, freelancing, and other regular income',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingL),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _incomeController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Monthly Income *',
                    labelStyle: const TextStyle(color: Colors.black54),
                    hintText: 'e.g., 50000',
                    hintStyle: const TextStyle(color: Colors.black38),
                    prefixIcon: const Icon(Icons.currency_rupee),
                    suffixText: 'INR',
                    suffixStyle: const TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your monthly income';
                    }
                    final income = double.tryParse(value);
                    if (income == null || income <= 0) {
                      return 'Please enter a valid income amount';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: AppColors.success, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This helps us calculate your savings potential and recommend suitable financial products',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : 
             _currentStep == 1 ? StepState.indexed : StepState.disabled,
    );
  }

  Step _buildExpensesStep() {
    return Step(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.warning,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Monthly Expenses',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
      content: FadeInUp(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warning.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tell us about your monthly spending habits',
                        style: TextStyle(
                          color: AppColors.warning.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingL),
              Text(
                'What are your monthly expenses?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: AppSizes.paddingS),
              Text(
                'Include rent, utilities, groceries, and other regular expenses',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.paddingL),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _expensesController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                    labelText: 'Monthly Expenses *',
                    labelStyle: TextStyle(color: Colors.black54),
                    hintText: 'e.g., 25000',
                    hintStyle: TextStyle(color: Colors.black38),
                    prefixIcon: Icon(Icons.shopping_cart, color: AppColors.warning),
                    suffixText: '₹',
                    suffixStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: AppColors.warning, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your monthly expenses';
                    }
                    final expenses = double.tryParse(value);
                    if (expenses == null || expenses < 0) {
                      return 'Please enter a valid expense amount';
                    }
                    
                    final income = double.tryParse(_incomeController.text) ?? 0;
                    if (expenses > income) {
                      return 'Expenses cannot be more than income';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tip: Your expenses should be less than your income for healthy finances',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isActive: _currentStep >= 2,
      state: _currentStep > 2 ? StepState.complete : 
             _currentStep == 2 ? StepState.indexed : StepState.disabled,
    );
  }

  Step _buildGoalsStep() {
    return Step(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.flag, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Financial Goals',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
      content: FadeInUp(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.success.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, color: AppColors.success, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Let\'s set your financial target for better planning',
                        style: TextStyle(
                          color: AppColors.success.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingL),
              Text(
                'What\'s your primary financial goal?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: AppSizes.paddingS),
              Text(
                'This will help us customize your financial recommendations',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.paddingL),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedGoal,
                  style: const TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                    labelText: 'Select Your Goal *',
                    labelStyle: TextStyle(color: Colors.black54),
                    hintText: 'Choose what matters most to you',
                    hintStyle: TextStyle(color: Colors.black38),
                    prefixIcon: Icon(Icons.flag, color: AppColors.success),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: AppColors.success, width: 2),
                    ),
                  ),
                  items: _goals.map((goal) => DropdownMenuItem(
                    value: goal,
                    child: Row(
                      children: [
                        Icon(_getGoalIcon(goal), size: 20, color: AppColors.success),
                        const SizedBox(width: 8),
                        Text(goal, style: const TextStyle(color: Colors.black87)),
                      ],
                    ),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedGoal = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a financial goal';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),
              if (_selectedGoal == 'Other')
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _goalController,
                    style: const TextStyle(color: Colors.black87),
                    decoration: const InputDecoration(
                      labelText: 'Specify your goal',
                      labelStyle: TextStyle(color: Colors.black54),
                      hintText: 'Tell us about your specific goal',
                      hintStyle: TextStyle(color: Colors.black38),
                      prefixIcon: Icon(Icons.edit, color: AppColors.success),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: AppColors.success, width: 2),
                      ),
                    ),
                    validator: _selectedGoal == 'Other' ? (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please specify your goal';
                      }
                      return null;
                    } : null,
                  ),
                ),
              const SizedBox(height: AppSizes.paddingM),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.psychology, color: Colors.purple, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'We\'ll create a personalized plan based on your goal',
                        style: TextStyle(
                          color: Colors.purple.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isActive: _currentStep >= 3,
      state: _currentStep == 3 ? StepState.indexed : StepState.disabled,
    );
  }

  Widget _buildStepperControls(BuildContext context, ControlsDetails details) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        children: [
          if (details.stepIndex < 3)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.touch_app, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Click "Continue" after filling the form above',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSizes.paddingM),
          Row(
            children: [
              if (details.stepIndex > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: details.onStepCancel,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text(
                      'Back',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              if (details.stepIndex > 0) const SizedBox(width: AppSizes.paddingM),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : () => _handleStepContinue(details),
                  icon: _isLoading 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(details.stepIndex == 3 ? Icons.check_circle : Icons.arrow_forward, color: Colors.white),
                  label: Text(
                    details.stepIndex == 3 ? 'Complete Setup' : 'Continue to Next Step',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'sans-serif',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: details.stepIndex == 3 ? AppColors.success : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getGoalIcon(String goal) {
    switch (goal) {
      case 'Emergency Fund': return Icons.security;
      case 'House Purchase': return Icons.home;
      case 'Investment Growth': return Icons.trending_up;
      case 'Debt Reduction': return Icons.money_off;
      case 'Retirement Planning': return Icons.elderly;
      case 'Other': return Icons.more_horiz;
      default: return Icons.flag;
    }
  }

  void _handleStepContinue(ControlsDetails details) async {
    if (details.stepIndex == 3) {
      _submitForm();
    } else {
      // For step 0, auto-expand form if not already expanded
      if (details.stepIndex == 0 && !_isFormExpanded) {
        setState(() {
          _isFormExpanded = true;
        });
        // Show a helpful message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Form expanded! Please fill in your information and continue.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      
      // Validate step 0 after form is expanded
      if (details.stepIndex == 0 && _nameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter your full name'),
          ),
        );
        return;
      }
      
      // Validate current step
      bool isValid = true;
      String errorMessage = '';
      
      switch (details.stepIndex) {
        case 0:
          isValid = _nameController.text.isNotEmpty;
          errorMessage = 'Please enter your full name';
          break;
        case 1:
          isValid = _incomeController.text.isNotEmpty && 
                   double.tryParse(_incomeController.text) != null;
          errorMessage = 'Please enter a valid monthly income';
          break;
        case 2:
          final expenses = double.tryParse(_expensesController.text);
          final income = double.tryParse(_incomeController.text) ?? 0;
          isValid = _expensesController.text.isNotEmpty && 
                   expenses != null && 
                   expenses <= income;
          errorMessage = 'Please enter valid expenses (must be less than income)';
          break;
        case 3:
          isValid = _selectedGoal != null && _selectedGoal!.isNotEmpty;
          errorMessage = 'Please select a financial goal';
          break;
      }
      
      if (isValid) {
        details.onStepContinue?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      final profile = UserProfile(
        name: _nameController.text.trim(),
        income: double.parse(_incomeController.text),
        expenses: double.parse(_expensesController.text),
        goal: _selectedGoal == 'Other' ? _goalController.text.trim() : _selectedGoal!,
      );
      
      context.read<CreditBloc>().add(FetchCreditScore(profile));
      
      // Simulate loading
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (mounted) {
        setState(() => _isLoading = false);
        context.go(AppRouter.dashboard);
      }
    }
  }
}
