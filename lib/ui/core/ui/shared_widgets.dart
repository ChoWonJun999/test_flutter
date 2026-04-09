import 'package:flutter/material.dart';

/// \ub370\uc774\ud130 \ub85c\ub4dc \uc2e4\ud328 \ub4f1 \uc624\ub958 \uc0c1\ud669\uc5d0 \ud45c\uc2dc\ud558\ub294 \uacf5\ud1b5 \uc5d0\ub7ec \uc704\uc82f.
class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    super.key,
    required this.title,
    required this.label,
    required this.onPressed,
  });

  final String title;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onPressed, child: Text(label)),
        ],
      ),
    );
  }
}
