import 'package:flutter/material.dart';

import '../services/patient_api_service.dart';
import 'order_medicines_screen.dart';
import 'order_tracking_screen.dart';
import 'refill_page_screen.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic> _summary = const {};
  List<Map<String, dynamic>> _todaySchedule = const [];
  List<Map<String, dynamic>> _refillAlerts = const [];
  List<Map<String, dynamic>> _orders = const [];
  final Set<String> _updatingScheduleIds = <String>{};

  @override
  void initState() {
    super.initState();
    _loadMedicationDashboard();
  }

  Future<void> _loadMedicationDashboard() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dashboard = await PatientApiService.getMedicationDashboard();
      final summary = _toMap(dashboard['summary']);
      final schedule = _mapList(dashboard['todaySchedule']);
      final refill = _mapList(dashboard['refillAlerts']);
      var orders = _mapList(dashboard['activeOrders']);
      if (orders.isEmpty) {
        orders = await PatientApiService.getMedicationOrders(limit: 5);
      }

      if (!mounted) return;
      setState(() {
        _summary = summary;
        _todaySchedule = schedule;
        _refillAlerts = refill;
        _orders = orders;
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

  bool _isTakenToday(Map<String, dynamic> schedule) {
    final lastTakenAt = DateTime.tryParse(schedule['lastTakenAt']?.toString() ?? '');
    if (lastTakenAt == null) return false;
    final now = DateTime.now();
    return lastTakenAt.year == now.year &&
        lastTakenAt.month == now.month &&
        lastTakenAt.day == now.day;
  }

  Future<void> _markTaken(Map<String, dynamic> schedule) async {
    final id = _text(schedule['id']);
    if (id.isEmpty || _updatingScheduleIds.contains(id)) return;

    setState(() => _updatingScheduleIds.add(id));
    try {
      await PatientApiService.markMedicationTaken(id);
      await _loadMedicationDashboard();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medication marked as taken')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(PatientApiService.friendlyError(error))),
      );
    } finally {
      if (mounted) {
        setState(() => _updatingScheduleIds.remove(id));
      }
    }
  }

  Future<void> _changeScheduleStatus(Map<String, dynamic> schedule, String action) async {
    final id = _text(schedule['id']);
    if (id.isEmpty || _updatingScheduleIds.contains(id)) return;

    setState(() => _updatingScheduleIds.add(id));
    try {
      await PatientApiService.updateMedicationScheduleStatus(
        scheduleId: id,
        action: action,
      );
      await _loadMedicationDashboard();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(PatientApiService.friendlyError(error))),
      );
    } finally {
      if (mounted) {
        setState(() => _updatingScheduleIds.remove(id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalDoses = _toInt(_summary['totalDosesToday']);
    final takenDoses = _toInt(_summary['takenDosesToday']);
    final percent = _toInt(_summary['adherencePercent']);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _loadMedicationDashboard,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
            children: [
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFD4822A)),
                  ),
                )
              else if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF6B3A1F),
                      fontSize: 13,
                    ),
                  ),
                )
              else ...[
                Container(
                  width: 160,
                  height: 160,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: (percent.clamp(0, 100)) / 100,
                        strokeWidth: 12,
                        backgroundColor: const Color(0xFFEFE2CC),
                        color: const Color(0xFFA0622A),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$percent%',
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF3B1F0A),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$takenDoses of $totalDoses doses taken',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF6B3A1F),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),

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
                if (_todaySchedule.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      'No medication schedule found yet.',
                      style: TextStyle(
                        color: Color(0xFF6B3A1F),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ..._todaySchedule.map((med) {
                  final isDone = _isTakenToday(med);
                  final scheduleId = _text(med['id']);
                  final medStatus = _text(med['status'], 'ACTIVE').toUpperCase();
                  final isPaused = medStatus == 'PAUSED';
                  final isUpdating = _updatingScheduleIds.contains(scheduleId);
                  final status = isDone ? 'Done' : 'Pending';
                  final statusBgColor =
                      isPaused ? Colors.grey.shade200 : (isDone ? Colors.green.shade100 : Colors.amber.shade100);
                  final statusTextColor =
                      isPaused ? Colors.grey.shade700 : (isDone ? Colors.green.shade700 : Colors.amber.shade700);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF6EC),
                      border: Border.all(color: const Color(0xFFEFE2CC)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_text(med['medicineName'], 'Medicine')} ${_text(med['dosage'])}',
                                    style: const TextStyle(
                                      color: Color(0xFF3B1F0A),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_formatTime(_text(med['timeOfDay']))}${isPaused ? ' - paused' : ''}',
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
                                isPaused ? 'Paused' : status,
                                style: TextStyle(
                                  color: statusTextColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: isUpdating || isDone || isPaused ? null : () => _markTaken(med),
                                icon: isUpdating
                                    ? const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.check_circle_outline, size: 16),
                                label: const Text('Mark Taken'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              enabled: !isUpdating,
                              onSelected: (action) => _changeScheduleStatus(med, action),
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  value: isPaused ? 'resume' : 'pause',
                                  child: Text(isPaused ? 'Resume' : 'Pause'),
                                ),
                                const PopupMenuItem(value: 'cancel', child: Text('Cancel')),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),

                if (_refillAlerts.isNotEmpty) ...[
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
                  ..._refillAlerts.map((med) {
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
                                  _text(med['medicineName'], 'Medicine'),
                                  style: TextStyle(
                                    color: Colors.amber.shade900,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Low stock - Qty ${_toInt(med['quantity'])} (reorder at ${_toInt(med['reorderLevel'])})',
                                  style: TextStyle(color: Colors.amber.shade700, fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RefillPageScreen(
                                          initialItems: _refillAlerts,
                                        ),
                                      ),
                                    );
                                    if (mounted) _loadMedicationDashboard();
                                  },
                                  child: Text(
                                    'Refill Now ->',
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
                  }),
                  const SizedBox(height: 16),
                ],

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrderMedicinesScreen()),
                      );
                      if (mounted) _loadMedicationDashboard();
                    },
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
                if (_orders.isEmpty)
                  const Text(
                    'No active orders.',
                    style: TextStyle(color: Color(0xFF6B3A1F), fontSize: 12),
                  ),
                ..._orders.map((order) {
                  final items = _mapList(order['items']);
                  final itemLabel = items.isEmpty
                      ? 'Medication order'
                      : '${_text(items.first['name'], 'Medicine')} x${_toInt(items.first['quantity'])}';
                  final expectedDelivery =
                      _text(order['expectedDeliveryAt']).isNotEmpty
                          ? _text(order['expectedDeliveryAt'])
                          : _text(order['orderedAt']);

                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderTrackingScreen(
                            orderId: _text(order['id']),
                          ),
                        ),
                      );
                      if (mounted) _loadMedicationDashboard();
                    },
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
                                _text(order['id']),
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
                            itemLabel,
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
                                _text(order['status']),
                                style: const TextStyle(
                                  color: Color(0xFFD4822A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Delivery: ${_formatDate(expectedDelivery)}',
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
                }),
              ],
            ],
          ),
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

  List<Map<String, dynamic>> _mapList(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((entry) => entry.map((k, v) => MapEntry(k.toString(), v)))
        .toList();
  }

  Map<String, dynamic> _toMap(dynamic value) {
    if (value is! Map) return const {};
    return value.map((k, v) => MapEntry(k.toString(), v));
  }

  String _formatTime(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length < 2) return hhmm;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final twelveHour = hour % 12 == 0 ? 12 : hour % 12;
    return '${twelveHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $suffix';
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
