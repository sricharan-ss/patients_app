import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'order_medicines_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  static const List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-001234',
      'status': 'Out for Delivery',
      'items': ['Metformin 500mg x 60', 'Lisinopril 10mg x 30'],
      'date': '2026-03-20T00:00:00Z',
      'total': 45.99,
      'cart': {'1': 1, '2': 1},
    },
    {
      'id': 'ORD-001235',
      'status': 'Delivered',
      'items': ['Aspirin 75mg x 90'],
      'date': '2026-03-15T00:00:00Z',
      'total': 12.99,
      'cart': {'3': 1},
    },
  ];

  @override
  Widget build(BuildContext context) {
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
        itemCount: _orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = _orders[index];
          final items = (order['items'] as List<dynamic>).cast<String>();
          final status = order['status'] as String;
          final isDelivered = status == 'Delivered';
          final statusBg = isDelivered ? const Color(0xFFD5F2DE) : const Color(0xFFF7E4BE);
          final statusText = isDelivered ? const Color(0xFF2E7D32) : AppColors.accent;

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
                  children: [
                    Expanded(
                      child: Text(
                        order['id'] as String,
                        style: const TextStyle(
                          color: AppColors.brownLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusText,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: AppColors.brownDeep,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _formatDate(order['date'] as String),
                        style: const TextStyle(
                          color: AppColors.brownMid,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                    onPressed: () {
                      final cart = Map<String, int>.from(order['cart'] as Map);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderMedicinesScreen(
                            initialCart: cart,
                            initialOrderId: order['id'] as String,
                          ),
                        ),
                      );
                    },
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
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return isoString;
    }
  }
}
