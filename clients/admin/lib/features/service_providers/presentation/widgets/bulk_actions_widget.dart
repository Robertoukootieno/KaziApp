import 'package:flutter/material.dart';

class BulkActionsWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onBulkApprove;
  final VoidCallback onBulkReject;
  final VoidCallback? onClearSelection;

  const BulkActionsWidget({
    super.key,
    required this.selectedCount,
    required this.onBulkApprove,
    required this.onBulkReject,
    this.onClearSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '$selectedCount registration${selectedCount == 1 ? '' : 's'} selected',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          
          // Bulk approve button
          ElevatedButton.icon(
            onPressed: onBulkApprove,
            icon: const Icon(Icons.check, size: 16),
            label: const Text('Approve All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 8),
          
          // Bulk reject button
          ElevatedButton.icon(
            onPressed: onBulkReject,
            icon: const Icon(Icons.close, size: 16),
            label: const Text('Reject All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 8),
          
          // Clear selection button
          TextButton.icon(
            onPressed: onClearSelection,
            icon: const Icon(Icons.clear, size: 16),
            label: const Text('Clear'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
