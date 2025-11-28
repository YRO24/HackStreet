import 'package:flutter/material.dart';

class ScoreGauge extends StatelessWidget {
  final int score;

  const ScoreGauge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('GenFi Score', style: TextStyle(fontSize: 20)),
        const SizedBox(height: 10),
        Stack(
          alignment: Alignment.center,
          children: [
            const SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: 0.7, // Mock value based on score
                strokeWidth: 10,
                backgroundColor: Colors.grey,
              ),
            ),
            Text(
              '$score',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
