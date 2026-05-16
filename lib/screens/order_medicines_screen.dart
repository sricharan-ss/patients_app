import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class OrderMedicinesScreen extends StatefulWidget {
  const OrderMedicinesScreen({
    super.key,
    this.initialCart,
    this.initialOrderId,
  });

  final Map<String, int>? initialCart;
  final String? initialOrderId;

  @override
  State<OrderMedicinesScreen> createState() => _OrderMedicinesScreenState();
}

class _OrderMedicinesScreenState extends State<OrderMedicinesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, int> _cart = {};
  String _searchQuery = '';

  final List<Map<String, dynamic>> _previouslyOrdered = [
    {'id': '1', 'name': 'Metformin', 'dosage': '500mg', 'price': 12.99},
    {'id': '2', 'name': 'Lisinopril', 'dosage': '10mg', 'price': 18.99},
    {'id': '3', 'name': 'Aspirin', 'dosage': '75mg', 'price': 8.99},
    {'id': '4', 'name': 'Vitamin D3', 'dosage': '1000 IU', 'price': 15.99},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCart != null) {
      _cart.addAll(widget.initialCart!);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.initialOrderId == null || _cartItemCount == 0) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reorder loaded from ${widget.initialOrderId}'),
          backgroundColor: AppColors.brownDeep,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateQuantity(String id, int change) {
    setState(() {
      final current = _cart[id] ?? 0;
      final next = current + change;
      if (next <= 0) {
        _cart.remove(id);
      } else {
        _cart[id] = next;
      }
    });
  }

  List<Map<String, dynamic>> get _filteredItems {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return _previouslyOrdered;
    }
    return _previouslyOrdered.where((item) {
      final label = '${item['name']} ${item['dosage']}'.toLowerCase();
      return label.contains(query);
    }).toList();
  }

  double get _cartTotal {
    var total = 0.0;
    _cart.forEach((id, qty) {
      final matching = _previouslyOrdered.where((item) => item['id'] == id);
      if (matching.isNotEmpty) {
        total += (matching.first['price'] as double) * qty;
      }
    });
    return total;
  }

  int get _cartItemCount {
    var count = 0;
    for (final qty in _cart.values) {
      count += qty;
    }
    return count;
  }

  void _placeOrder() {
    final orderTotal = _cartTotal.toStringAsFixed(2);
    setState(_cart.clear);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order placed successfully. Total: \$$orderTotal'),
        backgroundColor: AppColors.brownDeep,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasItems = _cartItemCount > 0;
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        title: const Text(
          'Order Medicines',
          style: TextStyle(
            color: AppColors.cream,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.brownDeep,
        iconTheme: const IconThemeData(color: AppColors.cream),
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search medicines...',
                      hintStyle: TextStyle(color: AppColors.brownMid.withOpacity(0.5)),
                      prefixIcon: const Icon(Icons.search, color: AppColors.brownMid),
                      filled: true,
                      fillColor: AppColors.cream,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.surface),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.surface),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Previously Ordered',
                    style: TextStyle(
                      color: AppColors.brownDeep,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (items.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        border: Border.all(color: AppColors.surface),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'No medicines match your search.',
                        style: TextStyle(color: AppColors.brownMid, fontSize: 13),
                      ),
                    ),
                  ...items.map((item) {
                    final id = item['id'] as String;
                    final qty = _cart[id] ?? 0;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        border: Border.all(color: AppColors.surface),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item['name']} ${item['dosage']}',
                            style: const TextStyle(
                              color: AppColors.brownDeep,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '\$${(item['price'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          qty > 0
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _QtyButton(
                                      icon: Icons.remove,
                                      onTap: () => _updateQuantity(id, -1),
                                      fill: AppColors.surface,
                                      iconColor: AppColors.brownMid,
                                    ),
                                    SizedBox(
                                      width: 36,
                                      child: Text(
                                        '$qty',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: AppColors.brownDeep,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    _QtyButton(
                                      icon: Icons.add,
                                      onTap: () => _updateQuantity(id, 1),
                                      fill: AppColors.accent,
                                      iconColor: AppColors.warmWhite,
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => _updateQuantity(id, 1),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.brownDeep,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Add to Cart',
                                      style: TextStyle(
                                        color: AppColors.cream,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    );
                  }),
                  if (hasItems) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        color: AppColors.brownDeep,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _InfoCard(
                      title: 'Home',
                      subtitle: '123 Main Street, Apt 4B\nNew York, NY 10001',
                      actionLabel: 'Change Address',
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        color: AppColors.brownDeep,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _InfoCard(
                      title: 'Credit Card',
                      subtitle: '**** **** **** 4242',
                      actionLabel: 'Change Payment',
                    ),
                  ],
                ],
              ),
            ),
            if (hasItems)
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.warmWhite,
                    border: Border(top: BorderSide(color: AppColors.surface)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$_cartItemCount ${_cartItemCount == 1 ? 'item' : 'items'}',
                              style: const TextStyle(
                                color: AppColors.brownMid,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '\$${_cartTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.brownDeep,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _placeOrder,
                          icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                          label: const Text('Place Order'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brownDeep,
                            foregroundColor: AppColors.cream,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.fill,
    required this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color fill;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: fill,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 16),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
  });

  final String title;
  final String subtitle;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
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
          Text(
            title,
            style: const TextStyle(
              color: AppColors.brownDeep,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.brownMid,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            actionLabel,
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
