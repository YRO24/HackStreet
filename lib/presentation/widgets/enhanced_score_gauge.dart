import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../core/theme/app_theme.dart';

class EnhancedScoreGauge extends StatelessWidget {
  final int score;
  final Map<String, dynamic> breakdown;

  const EnhancedScoreGauge({
    super.key,
    required this.score,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = score / 900.0;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Your GenFi Score',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
          
          // Circular Progress Indicator
          ElasticIn(
            child: CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 12.0,
              percent: percentage,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$score',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'out of 900',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              progressColor: Colors.white,
              backgroundColor: Colors.white.withOpacity(0.2),
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1500,
            ),
          ),
          
          const SizedBox(height: AppSizes.paddingL),
          
          // Score Category
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical: AppSizes.paddingS,
            ),
            decoration: BoxDecoration(
              color: _getScoreColor(score).withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              border: Border.all(
                color: _getScoreColor(score),
                width: 1,
              ),
            ),
            child: Text(
              _getScoreCategory(score),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _getScoreColor(score),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: AppSizes.paddingM),
          
          // Score breakdown
          _buildBreakdownItems(context),
        ],
      ),
    );
  }

  Widget _buildBreakdownItems(BuildContext context) {
    final items = breakdown.entries.take(3).toList();
    
    return Column(
      children: items.map((entry) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSizes.paddingS),
            Expanded(
              child: Text(
                '${entry.key}: ${entry.value}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 750) return Colors.green;
    if (score >= 650) return Colors.orange;
    return Colors.red;
  }

  String _getScoreCategory(int score) {
    if (score >= 750) return 'Excellent';
    if (score >= 700) return 'Good';
    if (score >= 650) return 'Fair';
    return 'Poor';
  }
}