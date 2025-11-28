import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../core/theme/app_theme.dart';
import '../models/gamification_models.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;
  
  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        title: Text(
          transaction.type == TransactionType.income ? 'Income Details' : 'Expense Details',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Header Card
            FadeInDown(
              child: _buildTransactionHeader(),
            ),
            
            const SizedBox(height: 24),
            
            // Description Section
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: _buildDescriptionSection(),
            ),
            
            const SizedBox(height: 24),
            
            // Rating Section
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: _buildRatingSection(context),
            ),
            
            const SizedBox(height: 24),
            
            // Portfolio Impact Section
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: _buildPortfolioImpactSection(),
            ),
            
            const SizedBox(height: 24),
            
            // EXP and Gamification Section
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: _buildExpSection(),
            ),
            
            const SizedBox(height: 24),
            
            // Additional Details
            FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: _buildAdditionalDetails(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: transaction.type == TransactionType.income 
            ? AppColors.successGradient 
            : const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (transaction.type == TransactionType.income 
                ? AppColors.success 
                : AppColors.error).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            transaction.type == TransactionType.income 
                ? Icons.trending_up 
                : Icons.trending_down,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            transaction.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${transaction.type == TransactionType.income ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            transaction.category,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Description',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            transaction.description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          if (transaction.notes != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.note,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      transaction.notes!,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star_rate,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Financial Decision Rating',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRatingButton(
                  TransactionRating.bad,
                  'Bad',
                  Colors.red,
                  Icons.thumb_down,
                  transaction.rating == TransactionRating.bad,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildRatingButton(
                  TransactionRating.okay,
                  'Okay',
                  Colors.orange,
                  Icons.horizontal_rule,
                  transaction.rating == TransactionRating.okay,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildRatingButton(
                  TransactionRating.good,
                  'Good',
                  Colors.green,
                  Icons.thumb_up,
                  transaction.rating == TransactionRating.good,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getRatingExplanation(transaction.rating),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingButton(
    TransactionRating rating,
    String label,
    Color color,
    IconData icon,
    bool isSelected,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
        border: Border.all(
          color: isSelected ? color : AppColors.outline.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? color : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? color : AppColors.textSecondary,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioImpactSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.trending_up,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Portfolio Impact',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Impact metrics
          Row(
            children: [
              Expanded(
                child: _buildImpactMetric(
                  'Immediate',
                  transaction.portfolioImpact.immediateImpact,
                  Icons.flash_on,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildImpactMetric(
                  'Long-term',
                  transaction.portfolioImpact.longTermProjection,
                  Icons.timeline,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Impact description
          Text(
            transaction.portfolioImpact.impactDescription,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Affected categories
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: transaction.portfolioImpact.affectedCategories.map((category) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactMetric(String label, double value, IconData icon) {
    final isPositive = value >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            '${isPositive ? '+' : ''}\$${value.abs().toStringAsFixed(0)}',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpSection() {
    return Container(
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.stars, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Experience Gained',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '+${transaction.expGained} EXP',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _getExpExplanation(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transaction Details',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildDetailRow('Date', '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}'),
          _buildDetailRow('Time', '${transaction.date.hour.toString().padLeft(2, '0')}:${transaction.date.minute.toString().padLeft(2, '0')}'),
          if (transaction.location != null)
            _buildDetailRow('Location', transaction.location!),
          _buildDetailRow('Transaction ID', transaction.id),
          
          const SizedBox(height: 16),
          
          // Tags
          if (transaction.tags.isNotEmpty) ...[
            const Text(
              'Tags',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: transaction.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.outline.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '#$tag',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingExplanation(TransactionRating rating) {
    switch (rating) {
      case TransactionRating.good:
        return 'This was a smart financial decision that aligns with your goals and contributes positively to your financial health.';
      case TransactionRating.okay:
        return 'This decision was acceptable but could have been optimized. Consider alternatives for better outcomes.';
      case TransactionRating.bad:
        return 'This decision may have negative impacts on your financial goals. Review and learn for future decisions.';
    }
  }

  String _getExpExplanation() {
    final baseExp = ExpSystem.baseExpRewards[transaction.rating] ?? 0;
    final multiplier = ExpSystem.categoryMultipliers[transaction.category] ?? 1.0;
    
    return 'Base: ${baseExp} EXP • Category: ${multiplier}x • ${transaction.rating.name.toUpperCase()} choice';
  }
}