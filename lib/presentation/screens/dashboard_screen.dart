import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _DashboardContent(),
    const _PlanningContent(),
    const _AnalyticsContent(),
    const _ProfileContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0 ? _buildAppBar(context) : null,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Morning!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          Text(
            'John Doe',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
        ),
        IconButton(
          onPressed: () => context.go(AppRouter.profile),
          icon: const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 20, color: AppColors.primary),
          ),
        ),
        const SizedBox(width: AppSizes.paddingS),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Planning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreditBloc, CreditState>(
      builder: (context, state) {
        if (state is CreditLoading) {
          return const EnhancedLoadingIndicator();
        } else if (state is CreditLoaded) {
          return _buildDashboardContent(context, state);
        } else if (state is CreditError) {
          return _buildErrorState(context, state.message);
        }
        return _buildInitialState(context);
      },
    );
  }

  Widget _buildDashboardContent(BuildContext context, CreditLoaded state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Credit Score Section with gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.paddingL,
                  AppSizes.paddingXL,
                  AppSizes.paddingL,
                  AppSizes.paddingXL,
                ),
                child: FadeInDown(
                  child: EnhancedScoreGauge(
                    score: state.analysis.score,
                    breakdown: state.analysis.breakdown,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: AppSizes.paddingL),
          
          // Quick Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
            child: FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Row(
                children: [
                  Expanded(
                    child: DashboardStatCard(
                      title: 'Monthly Savings',
                      value: '₹40,000',
                      icon: Icons.savings,
                      color: AppColors.success,
                      trend: '+12%',
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: DashboardStatCard(
                      title: 'Credit Utilization',
                      value: '15%',
                      icon: Icons.credit_card,
                      color: AppColors.primary,
                      trend: '-5%',
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppSizes.paddingL),
          
          // Enhanced Plan Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
            child: FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: EnhancedPlanCard(plan: state.analysis.plan),
            ),
          ),
          
          const SizedBox(height: AppSizes.paddingL),
          
          // Quick Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
            child: FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  Row(
                    children: [
                      Expanded(
                        child: QuickActionCard(
                          title: 'Financial Planning',
                          subtitle: 'Set goals & track progress',
                          icon: Icons.trending_up,
                          color: AppColors.success,
                          onTap: () => context.go(AppRouter.financialPlanning),
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingM),
                      Expanded(
                        child: QuickActionCard(
                          title: 'Credit Details',
                          subtitle: 'View detailed analysis',
                          icon: Icons.analytics,
                          color: AppColors.warning,
                          onTap: () => context.go(AppRouter.creditDetails),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppSizes.paddingXL),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: FadeIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingL),
            ElevatedButton(
              onPressed: () {
                // Retry logic here
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: FadeIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'No Data Available',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              'Start by analyzing your financial profile',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),
            ElevatedButton(
              onPressed: () => context.go(AppRouter.onboarding),
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanningContent extends StatelessWidget {
  const _PlanningContent();

  @override
  Widget build(BuildContext context) {
    // This will be replaced by the actual FinancialPlanningScreen content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(AppRouter.financialPlanning);
    });
    return const SizedBox.shrink();
  }
}

class _AnalyticsContent extends StatelessWidget {
  const _AnalyticsContent();

  @override
  Widget build(BuildContext context) {
    // This will be replaced by the actual CreditDetailsScreen content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(AppRouter.creditDetails);
    });
    return const SizedBox.shrink();
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    // This will be replaced by the actual ProfileScreen content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(AppRouter.profile);
    });
    return const SizedBox.shrink();
  }
}
