import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'refill_page_screen.dart';
import 'order_medicines_screen.dart';
import 'order_tracking_screen.dart';

class MedicationsScreen extends StatelessWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todaysMedications = [
      {'id': '1', 'name': 'Lisinopril', 'dosage': '10mg', 'time': '08:00 AM', 'status': 'Done'},
      {'id': '2', 'name': 'Metformin', 'dosage': '500mg', 'time': '01:00 PM', 'status': 'Pending'},
      {'id': '3', 'name': 'Atorvastatin', 'dosage': '20mg', 'time': '08:00 PM', 'status': 'Pending'},
    ];

    final medicationsRefill = [
      {'id': '1', 'name': 'Lisinopril', 'dosage': '10mg', 'refillDate': '2026-04-10T00:00:00Z'},
    ];

    final orders = [
      {
        'id': 'ORD-2026-002',
        'status': 'Dispatched',
        'items': ['Cough Syrup 100ml x 1'],
        'deliveryDate': '2026-04-09T00:00:00Z',
      }
    ];

    final completedCount = todaysMedications.where((m) => m['status'] == 'Done').length;
    final totalCount = todaysMedications.length;
    final percentage = totalCount > 0 ? (completedCount / totalCount * 100).round() : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Medication Ring Placeholder
              Container(
                width: 160,
                height: 160,
                margin: const EdgeInsets.only(bottom: 16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: percentage / 100,
                      strokeWidth: 12,
                      backgroundColor: const Color(0xFFEFE2CC),
                      color: const Color(0xFFA0622A),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$percentage%',
                            style: const TextStyle(
                              color: Color(0xFF3B1F0A),
                              fontSize: 36,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            'completed',
                            style: TextStyle(
                              color: Color(0xFFA0622A),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                "Today's Medications",
                style: TextStyle(
                  color: Color(0xFF3B1F0A),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$completedCount of $totalCount doses taken',
                style: const TextStyle(
                  color: Color(0xFF6B3A1F),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),

              // Filter Tabs
              Row(
                children: ['Today', 'Week', 'Month'].asMap().entries.map((entry) {
                  int idx = entry.key;
                  String tab = entry.value;
                  bool isSelected = idx == 0;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFD4822A) : const Color(0xFFFBF6EC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFFFFFDF8) : const Color(0xFF6B3A1F),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Today's Schedule
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Today's Schedule",
                  style: TextStyle(
                    color: Color(0xFF3B1F0A),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...todaysMedications.map((med) {
                bool isDone = med['status'] == 'Done';
                bool isPending = med['status'] == 'Pending';
                Color statusBgColor = isDone ? Colors.green.shade100 : (isPending ? Colors.amber.shade100 : Colors.red.shade100);
                Color statusTextColor = isDone ? Colors.green.shade700 : (isPending ? Colors.amber.shade700 : Colors.red.shade700);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF6EC),
                    border: Border.all(color: const Color(0xFFEFE2CC)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${med['name']} ${med['dosage']}',
                              style: const TextStyle(
                                color: Color(0xFF3B1F0A),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              med['time']!,
                              style: const TextStyle(
                                color: Color(0xFF6B3A1F),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          med['status']!,
                          style: TextStyle(
                            color: statusTextColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),

              // Refill Alerts
              if (medicationsRefill.isNotEmpty) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Refill Alerts',
                    style: TextStyle(
                      color: Color(0xFF3B1F0A),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...medicationsRefill.map((med) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      border: Border.all(color: Colors.amber.shade200),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.error_outline, color: Colors.amber.shade600, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${med['name']} ${med['dosage']}',
                                style: TextStyle(
                                  color: Colors.amber.shade900,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Low stock - Refill by ${_formatDate(med['refillDate']!)}',
                                style: TextStyle(color: Colors.amber.shade700, fontSize: 12),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RefillPageScreen())),
                                child: Text(
                                  'Refill Now →',
                                  style: TextStyle(
                                    color: Colors.amber.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
              ],

              // Order Medicines
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderMedicinesScreen())),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Order Medicines'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B1F0A),
                    foregroundColor: const Color(0xFFFBF6EC),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Ongoing Orders
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ongoing Orders',
                  style: TextStyle(
                    color: Color(0xFF3B1F0A),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...orders.map((order) {
                final item = (order['items'] as List<String>).first;
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderTrackingScreen(orderId: order['id'] as String))),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF6EC),
                      border: Border.all(color: const Color(0xFFEFE2CC)),
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
                                color: Color(0xFFA0622A),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Color(0xFFA0622A), size: 16),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item,
                          style: const TextStyle(
                            color: Color(0xFF3B1F0A),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order['status'] as String,
                              style: const TextStyle(
                                color: Color(0xFFD4822A),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Delivery: ${_formatDate(order['deliveryDate'] as String)}',
                              style: const TextStyle(
                                color: Color(0xFF6B3A1F),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}';
    } catch (_) {
      return isoString;
    }
  }
}
