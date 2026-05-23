import 'package:flutter/material.dart';

import '../services/patient_api_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic> _order = const {};

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final order = await PatientApiService.getMedicationOrderById(widget.orderId);
      if (!mounted) return;
      setState(() {
        _order = order;
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

  Future<void> _cancelOrder() async {
    try {
      await PatientApiService.cancelMedicationOrder(widget.orderId);
      await _loadOrder();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order cancelled')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(PatientApiService.friendlyError(error))),
      );
    }
  }

  List<Map<String, dynamic>> _buildSteps(String status) {
    final steps = ['PLACED', 'CONFIRMED', 'DISPATCHED', 'DELIVERED'];
    final activeIndex = steps.indexOf(status);

    return steps.asMap().entries.map((entry) {
      final idx = entry.key;
      final step = entry.value;
      final isCompleted = activeIndex >= idx;
      final isActive = activeIndex == idx;
      return {
        'label': _pretty(step),
        'completed': isCompleted,
        'active': isActive,
      };
    }).toList();
  }

  String _text(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  List<Map<String, dynamic>> _mapList(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((entry) => entry.map((k, v) => MapEntry(k.toString(), v)))
        .toList();
  }

  String _pretty(String value) {
    return value
        .toLowerCase()
        .split('_')
        .map((part) => part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final status = _text(_order['status'], 'PLACED').toUpperCase();
    final steps = _buildSteps(status);
    final items = _mapList(_order['items']);
    final canCancel = ['DRAFT', 'PLACED', 'CONFIRMED'].contains(status);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      appBar: AppBar(
        title: Text(
          'Track Order #${widget.orderId}',
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD4822A)),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF6B3A1F), fontSize: 13),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            Text(
                              'Status: ${_pretty(status)}',
                              style: const TextStyle(
                                color: Color(0xFF3B1F0A),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Ordered: ${_formatDate(_text(_order['orderedAt']))}',
                              style: const TextStyle(
                                color: Color(0xFF6B3A1F),
                                fontSize: 12,
                              ),
                            ),
                            if (_text(_order['expectedDeliveryAt']).isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                'Expected: ${_formatDate(_text(_order['expectedDeliveryAt']))}',
                                style: const TextStyle(
                                  color: Color(0xFF6B3A1F),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            if (canCancel) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _cancelOrder,
                                  icon: const Icon(Icons.cancel_outlined, size: 16),
                                  label: const Text('Cancel Order'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
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
                        final idx = entry.key;
                        final step = entry.value;
                        final isCompleted = step['completed'] as bool;
                        final isActive = step['active'] as bool;
                        final isLast = idx == steps.length - 1;

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
                                          : (isActive
                                              ? const Color(0xFFD4822A).withOpacity(0.3)
                                              : const Color(0xFFEFE2CC)),
                                      border: isActive
                                          ? Border.all(color: const Color(0xFFD4822A), width: 2)
                                          : null,
                                    ),
                                    child: isCompleted
                                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                                        : Center(
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isActive
                                                    ? const Color(0xFFD4822A)
                                                    : const Color(0xFFA0622A),
                                              ),
                                            ),
                                          ),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: isCompleted
                                            ? const Color(0xFFD4822A)
                                            : const Color(0xFFEFE2CC),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                                  child: Text(
                                    _text(step['label']),
                                    style: TextStyle(
                                      color: isCompleted || isActive
                                          ? const Color(0xFF3B1F0A)
                                          : const Color(0xFFA0622A),
                                      fontSize: 14,
                                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
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
                            const Text(
                              'Order Items',
                              style: TextStyle(
                                color: Color(0xFF3B1F0A),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (items.isEmpty)
                              const Text(
                                'No items',
                                style: TextStyle(color: Color(0xFF6B3A1F), fontSize: 13),
                              ),
                            ...items.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '${_text(item['name'], 'Medicine')} x${_text(item['quantity'], '1')}',
                                  style: const TextStyle(
                                    color: Color(0xFF6B3A1F),
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            }),
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
