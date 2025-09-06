import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;

  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            child,
          ],
        ),
      ),
    );
  }
}
