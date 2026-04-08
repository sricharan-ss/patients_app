import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    // Mock order detail based on the orderId passed
    final order = {
      'id': orderId,
      'date': '2026-04-09T10:00:00Z',
      'status': 'Out for Delivery',
      'expectedDelivery': '2026-04-10T14:00:00Z',
      'deliveryAgent': 'John Delivery',
      'deliveryPhone': '+1 234 567 8900',
    };

    final steps = [
      {'label': 'Order Placed', 'date': order['date'], 'completed': true, 'active': false},
      {'label': 'Confirmed', 'date': order['date'], 'completed': true, 'active': false},
      {'label': 'Dispatched', 'date': order['date'], 'completed': true, 'active': false},
      {'label': 'Out for Delivery', 'date': order['date'], 'completed': false, 'active': true},
      {'label': 'Delivered', 'date': order['expectedDelivery'], 'completed': false, 'active': false},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      appBar: AppBar(
        title: Text(
          'Track Order #${order['id']}',
          style: const TextStyle(
            color: Color(0xFFFBF6EC),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF3B1F0A),
        iconTheme: const IconThemeData(color: Color(0xFFFBF6EC)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Placeholder
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEFE2CC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'Delivery Map View',
                  style: TextStyle(
                    color: Color(0xFFA0622A),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Timeline
            const Text(
              'Order Status',
              style: TextStyle(
                color: Color(0xFF3B1F0A),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            ...steps.asMap().entries.map((entry) {
              int idx = entry.key;
              var step = entry.value;
              bool isCompleted = step['completed'] as bool;
              bool isActive = step['active'] as bool;
              bool isLast = idx == steps.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? const Color(0xFFD4822A)
                                : (isActive ? const Color(0xFFD4822A).withOpacity(0.3) : const Color(0xFFEFE2CC)),
                            border: isActive ? Border.all(color: const Color(0xFFD4822A), width: 2) : null,
                          ),
                          child: isCompleted
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isActive ? const Color(0xFFD4822A) : const Color(0xFFA0622A),
                                    ),
                                  ),
                                ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: isCompleted ? const Color(0xFFD4822A) : const Color(0xFFEFE2CC),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              step['label'] as String,
                              style: TextStyle(
                                color: isCompleted || isActive ? const Color(0xFF3B1F0A) : const Color(0xFFA0622A),
                                fontSize: 14,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(step['date'] as String),
                              style: const TextStyle(
                                color: Color(0xFFA0622A),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Delivery Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF6EC),
                border: Border.all(color: const Color(0xFFEFE2CC)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Delivery Details', style: TextStyle(color: Color(0xFF3B1F0A), fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined, color: Color(0xFF6B3A1F), size: 16),
                      const SizedBox(width: 8),
                      Text(order['deliveryAgent'] as String, style: const TextStyle(color: Color(0xFF6B3A1F), fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, color: Color(0xFF6B3A1F), size: 16),
                      const SizedBox(width: 8),
                      Text(order['deliveryPhone'] as String, style: const TextStyle(color: Color(0xFF6B3A1F), fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
