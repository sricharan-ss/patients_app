import 'package:flutter/material.dart';

class OrderMedicinesScreen extends StatefulWidget {
  const OrderMedicinesScreen({super.key});

  @override
  State<OrderMedicinesScreen> createState() => _OrderMedicinesScreenState();
}

class _OrderMedicinesScreenState extends State<OrderMedicinesScreen> {
  String searchQuery = '';
  final Map<String, int> cart = {};

  final List<Map<String, dynamic>> previouslyOrdered = [
    {'id': '1', 'name': 'Metformin', 'dosage': '500mg', 'price': 12.99},
    {'id': '2', 'name': 'Lisinopril', 'dosage': '10mg', 'price': 18.99},
    {'id': '3', 'name': 'Aspirin', 'dosage': '75mg', 'price': 8.99},
    {'id': '4', 'name': 'Vitamin D3', 'dosage': '1000 IU', 'price': 15.99},
  ];

  void updateQuantity(String id, int change) {
    setState(() {
      int current = cart[id] ?? 0;
      int next = current + change;
      if (next <= 0) {
        cart.remove(id);
      } else {
        cart[id] = next;
      }
    });
  }

  double get cartTotal {
    double total = 0;
    cart.forEach((id, qty) {
      final item = previouslyOrdered.firstWhere((i) => i['id'] == id);
      total += (item['price'] as double) * qty;
    });
    return total;
  }

  int get cartItemCount {
    int count = 0;
    for (var qty in cart.values) count += qty;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    bool hasItems = cartItemCount > 0;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      appBar: AppBar(
        title: const Text(
          'Order Medicines',
          style: TextStyle(
            color: Color(0xFFFBF6EC),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF3B1F0A),
        iconTheme: const IconThemeData(color: Color(0xFFFBF6EC)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(16, 20, 16, hasItems ? 120 : 20),
            children: [
              // Search
              TextField(
                onChanged: (val) => setState(() => searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search medicines...',
                  hintStyle: TextStyle(color: const Color(0xFF6B3A1F).withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF6B3A1F)),
                  filled: true,
                  fillColor: const Color(0xFFFBF6EC),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFEFE2CC)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFEFE2CC)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFD4822A)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Previously Ordered
              const Text(
                'Previously Ordered',
                style: TextStyle(
                  color: Color(0xFF3B1F0A),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ...previouslyOrdered.map((item) {
                final id = item['id'] as String;
                final qty = cart[id] ?? 0;
                return Container(
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item['name']} ${item['dosage']}',
                                style: const TextStyle(
                                  color: Color(0xFF3B1F0A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '\$${(item['price'] as double).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xFFD4822A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      qty > 0
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTap: () => updateQuantity(id, -1),
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEFE2CC),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.remove, color: Color(0xFF6B3A1F), size: 16),
                                  ),
                                ),
                                SizedBox(
                                  width: 32,
                                  child: Text(
                                    qty.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF3B1F0A),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => updateQuantity(id, 1),
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD4822A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.add, color: Color(0xFFFFFDF8), size: 16),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => updateQuantity(id, 1),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B1F0A),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: const Text('Add to Cart', style: TextStyle(color: Color(0xFFFBF6EC), fontSize: 13)),
                              ),
                            ),
                    ],
                  ),
                );
              }),

              if (hasItems) ...[
                const SizedBox(height: 20),
                const Text('Delivery Address', style: TextStyle(color: Color(0xFF3B1F0A), fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
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
                      const Text('Home', style: TextStyle(color: Color(0xFF3B1F0A), fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      const Text('123 Main Street, Apt 4B\nNew York, NY 10001', style: TextStyle(color: Color(0xFF6B3A1F), fontSize: 13)),
                      const SizedBox(height: 8),
                      Text('Change Address', style: TextStyle(color: const Color(0xFFD4822A), fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                const Text('Payment Method', style: TextStyle(color: Color(0xFF3B1F0A), fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
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
                      const Text('Credit Card', style: TextStyle(color: Color(0xFF3B1F0A), fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      const Text('•••• •••• •••• 4242', style: TextStyle(color: Color(0xFF6B3A1F), fontSize: 13)),
                      const SizedBox(height: 8),
                      Text('Change Payment', style: TextStyle(color: const Color(0xFFD4822A), fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ],
          ),

          if (hasItems)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFDF8),
                  border: Border(top: BorderSide(color: Color(0xFFEFE2CC))),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$cartItemCount ${cartItemCount == 1 ? 'item' : 'items'}', style: const TextStyle(color: Color(0xFF6B3A1F), fontSize: 13)),
                        Text('\$${cartTotal.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF3B1F0A), fontSize: 18, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed successfully!')));
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                        label: const Text('Place Order'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B1F0A),
                          foregroundColor: const Color(0xFFFBF6EC),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
