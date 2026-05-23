import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../services/patient_api_service.dart';

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
  List<Map<String, dynamic>> _medicines = const [];
  String _searchQuery = '';
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialCart != null) {
      _cart.addAll(widget.initialCart!);
    }
    _loadMedicines();

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

  Future<void> _loadMedicines() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final medicines = await PatientApiService.getOrderableMedicines();
      if (!mounted) return;
      setState(() {
        _medicines = medicines;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = PatientApiService.friendlyError(error);
        _isLoading = false;
      });
    }
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
      return _medicines;
    }
    return _medicines.where((item) {
      final label = '${item['name']} ${item['dosage']}'.toLowerCase();
      return label.contains(query);
    }).toList();
  }

  double get _cartTotal {
    var total = 0.0;
    _cart.forEach((id, qty) {
      final matching = _medicines.where((item) => _text(item['id']) == id);
      if (matching.isNotEmpty) {
        total += _toDouble(matching.first['price']) * qty;
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

  Future<void> _placeOrder() async {
    if (_cart.isEmpty || _isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      final items = _cart.entries.map((entry) {
        final med = _medicines.firstWhere(
          (item) => _text(item['id']) == entry.key,
          orElse: () => const <String, dynamic>{},
        );
        return {
          'medicineId': _text(med['medicineId'], entry.key),
          if (_text(med['prescriptionMedicineId']).isNotEmpty)
            'prescriptionMedicineId': _text(med['prescriptionMedicineId']),
          'quantity': entry.value,
          if (_text(med['dosage']).isNotEmpty) 'dosage': _text(med['dosage']),
          if (_text(med['frequency']).isNotEmpty) 'frequency': _text(med['frequency']),
          if (_toInt(med['durationDays']) > 0) 'durationDays': _toInt(med['durationDays']),
          if (_toDouble(med['price']) > 0) 'unitPrice': _toDouble(med['price']),
        };
      }).toList();

      final first = _medicines.firstWhere(
        (item) => _cart.containsKey(_text(item['id'])),
        orElse: () => const <String, dynamic>{},
      );
      await PatientApiService.createMedicationOrder(
        hospitalId: _text(first['hospitalId']),
        sourcePrescriptionId: _text(first['prescriptionId']),
        orderType: widget.initialOrderId == null ? 'NEW' : 'REORDER',
        items: items,
      );

      if (!mounted) return;
      setState(_cart.clear);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully'),
          backgroundColor: AppColors.brownDeep,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(PatientApiService.friendlyError(error))),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
                    'Available From Prescriptions',
                    style: TextStyle(
                      color: AppColors.brownDeep,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: CircularProgressIndicator(color: AppColors.accent)),
                    )
                  else if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        border: Border.all(color: AppColors.surface),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: AppColors.brownMid, fontSize: 13),
                      ),
                    )
                  else if (items.isEmpty)
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
                    final id = _text(item['id']);
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
                            _toDouble(item['price']) > 0
                                ? 'Rs. ${_toDouble(item['price']).toStringAsFixed(2)}'
                                : 'Prescription medicine',
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
                            'Rs. ${_cartTotal.toStringAsFixed(2)}',
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
                          onPressed: _isSubmitting ? null : _placeOrder,
                          icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                          label: Text(_isSubmitting ? 'Placing...' : 'Place Order'),
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

  String _text(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  int _toInt(dynamic value, [int fallback = 0]) {
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  double _toDouble(dynamic value, [double fallback = 0]) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
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
