import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Merged mock data from user's version
    final orders = [
      {
        'id': 'ORD-2026-001',
        'status': 'Delivered',
        'items': ['Paracetamol 500mg x 2', 'Vitamin C Supplements x 1'],
        'date': '2026-03-28T10:00:00Z',
        'total': 24.50,
      },
      {
        'id': 'ORD-2026-002',
        'status': 'Processing',
        'items': ['Cough Syrup 100ml x 1'],
        'date': '2026-04-05T14:30:00Z',
        'total': 12.00,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(
            color: AppColors.cream,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.brownDeep,
        iconTheme: const IconThemeData(color: AppColors.cream),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = orders[index];
          final items = order['items'] as List<String>;
          final status = order['status'] as String;
          final isDelivered = status == 'Delivered';

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cream,
              border: Border.all(color: AppColors.surface),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['id'] as String,
                      style: const TextStyle(
                        color: AppColors.brownLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDelivered ? const Color(0xFFD5F2DE) : const Color(0xFFF7E4BE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: isDelivered ? const Color(0xFF2E7D32) : AppColors.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: AppColors.brownDeep,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(order['date'] as String),
                      style: const TextStyle(
                        color: AppColors.brownMid,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '\$${(order['total'] as double).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.brownDeep,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Reorder'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brownDeep,
                      foregroundColor: AppColors.cream,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return isoString;
    }
  }
}
