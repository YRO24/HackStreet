import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;

  const PlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recommended Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Monthly Savings: ₹${plan['monthly_savings']}'),
            Text('Suggested EMI: ₹${plan['suggested_emi']}'),
            Text('Tenure: ${plan['tenure_months']} months'),
          ],
        ),
      ),
    );
  }
}
