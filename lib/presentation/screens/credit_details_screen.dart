import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';

class CreditDetailsScreen extends StatelessWidget {
  const CreditDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          children: [
            FadeInDown(
              child: _buildCreditScoreCard(context),
            ),
            const SizedBox(height: AppSizes.paddingL),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: _buildCreditFactors(context),
            ),
            const SizedBox(height: AppSizes.paddingL),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: _buildCreditHistory(context),
            ),
            const SizedBox(height: AppSizes.paddingL),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: _buildRecommendations(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditScoreCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Credit Score',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Excellent',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingL),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      startDegreeOffset: 270,
                      sectionsSpace: 0,
                      centerSpaceRadius: 60,
                      sections: [
                        PieChartSectionData(
                          value: 785,
                          color: AppColors.success,
                          radius: 20,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: 215,
                          color: AppColors.surfaceVariant,
                          radius: 20,
                          showTitle: false,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '785',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                      Text(
                        'out of 900',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Last updated: Nov 28, 2025',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditFactors(BuildContext context) {
    final factors = [
      {'name': 'Payment History', 'score': 95, 'impact': 'High'},
      {'name': 'Credit Utilization', 'score': 88, 'impact': 'High'},
      {'name': 'Length of Credit History', 'score': 82, 'impact': 'Medium'},
      {'name': 'Credit Mix', 'score': 75, 'impact': 'Low'},
      {'name': 'New Credit', 'score': 90, 'impact': 'Low'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Credit Factors',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSizes.paddingM),
            ...factors.map((factor) => _buildFactorItem(
              context,
              factor['name'] as String,
              factor['score'] as int,
              factor['impact'] as String,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildFactorItem(
    BuildContext context,
    String name,
    int score,
    String impact,
  ) {
    Color impactColor;
    switch (impact.toLowerCase()) {
      case 'high':
        impactColor = AppColors.error;
        break;
      case 'medium':
        impactColor = AppColors.warning;
        break;
      default:
        impactColor = AppColors.success;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: Theme.of(context).textTheme.bodyLarge),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: impactColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      impact,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: impactColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$score%',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: score / 100,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              score >= 80 ? AppColors.success : 
              score >= 60 ? AppColors.warning : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditHistory(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Credit Score Trend',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSizes.paddingM),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 720),
                        FlSpot(1, 735),
                        FlSpot(2, 750),
                        FlSpot(3, 765),
                        FlSpot(4, 785),
                      ],
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(BuildContext context) {
    final recommendations = [
      {
        'title': 'Keep Credit Utilization Low',
        'description': 'Maintain credit card balances below 30% of limits',
        'icon': Icons.credit_card,
      },
      {
        'title': 'Make Payments on Time',
        'description': 'Set up auto-pay to avoid late payments',
        'icon': Icons.schedule,
      },
      {
        'title': 'Monitor Your Credit Report',
        'description': 'Check for errors and dispute inaccuracies',
        'icon': Icons.visibility,
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommendations',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSizes.paddingM),
            ...recommendations.map((rec) => ListTile(
              leading: Icon(
                rec['icon'] as IconData,
                color: AppColors.primary,
              ),
              title: Text(rec['title'] as String),
              subtitle: Text(rec['description'] as String),
              contentPadding: EdgeInsets.zero,
            )),
          ],
        ),
      ),
    );
  }
}