import 'package:flutter/material.dart';

import '../services/patient_api_service.dart';

class RefillPageScreen extends StatefulWidget {
  const RefillPageScreen({
    super.key,
    this.initialItems = const [],
  });

  final List<Map<String, dynamic>> initialItems;

  @override
  State<RefillPageScreen> createState() => _RefillPageScreenState();
}

class _RefillPageScreenState extends State<RefillPageScreen> {
  late final List<Map<String, dynamic>> medicationsRefill;
  Map<String, dynamic>? selectedMed;
  int quantity = 30;
  String deliveryDate = DateTime.now()
      .add(const Duration(days: 2))
      .toIso8601String()
      .split('T')[0];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    medicationsRefill = _buildRefillItems(widget.initialItems);
    if (medicationsRefill.isNotEmpty) {
      selectedMed = medicationsRefill.first;
    }
  }

  List<Map<String, dynamic>> _buildRefillItems(List<Map<String, dynamic>> incoming) {
    if (incoming.isNotEmpty) {
      return incoming.map((item) {
        final medicineId = _text(item['medicineId'], _text(item['id']));
        return {
          'id': _text(item['id'], medicineId),
          'medicineId': medicineId,
          'hospitalId': _text(item['hospitalId']),
          'name': _text(item['medicineName'], 'Medicine'),
          'dosage': _text(item['dosage'], ''),
          'refillDate': DateTime.now().toUtc().toIso8601String(),
        };
      }).toList();
    }

    return [
      {
        'id': 'local-1',
        'medicineId': '',
        'hospitalId': '',
        'name': 'Medication',
        'dosage': '',
        'refillDate': DateTime.now().toUtc().toIso8601String(),
      },
    ];
  }

  Future<void> _submitRefill() async {
    if (selectedMed == null) return;
    final medicineId = _text(selectedMed!['medicineId']);
    if (medicineId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicine id is missing for this refill item')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final expected = DateTime.tryParse('${deliveryDate}T10:00:00');
      await PatientApiService.createMedicationRefill(
        hospitalId: _text(selectedMed!['hospitalId']),
        notes: expected == null ? null : 'Requested delivery on $deliveryDate',
        items: [
          {
            'medicineId': medicineId,
            'quantity': quantity,
            'dosage': _text(selectedMed!['dosage']),
          },
        ],
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Refill order placed successfully!')),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(PatientApiService.friendlyError(error))),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      appBar: AppBar(
        title: const Text(
          'Refill Medication',
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
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
            children: [
              const Text(
                'Select Medication',
                style: TextStyle(
                  color: Color(0xFFA0622A),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              ...medicationsRefill.map((med) {
                final isSelected = selectedMed?['id'] == med['id'];
                return GestureDetector(
                  onTap: () => setState(() => selectedMed = med),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF6EC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFD4822A) : const Color(0xFFEFE2CC),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_text(med['name'])} ${_text(med['dosage'])}',
                          style: const TextStyle(
                            color: Color(0xFF3B1F0A),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Current refill due: ${_formatDate(_text(med['refillDate']))}',
                          style: TextStyle(
                            color: Colors.amber.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),

              const Text(
                'Quantity (pills)',
                style: TextStyle(
                  color: Color(0xFFA0622A),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF6EC),
                  border: Border.all(color: const Color(0xFFEFE2CC)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: quantity,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B3A1F)),
                    items: const [
                      DropdownMenuItem(value: 30, child: Text('30 pills (1 month)')),
                      DropdownMenuItem(value: 60, child: Text('60 pills (2 months)')),
                      DropdownMenuItem(value: 90, child: Text('90 pills (3 months)')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => quantity = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Preferred Delivery Date',
                style: TextStyle(
                  color: Color(0xFFA0622A),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(text: deliveryDate),
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      deliveryDate = picked.toIso8601String().split('T')[0];
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF6B3A1F), size: 18),
                  filled: true,
                  fillColor: const Color(0xFFFBF6EC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFEFE2CC)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFEFE2CC)),
                  ),
                ),
              ),
            ],
          ),
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
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRefill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B1F0A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFFBF6EC),
                        ),
                      )
                    : const Text(
                        'Confirm Refill Order',
                        style: TextStyle(color: Color(0xFFFBF6EC), fontSize: 15),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _text(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
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
