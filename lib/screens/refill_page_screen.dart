import 'package:flutter/material.dart';

class RefillPageScreen extends StatefulWidget {
  const RefillPageScreen({super.key});

  @override
  State<RefillPageScreen> createState() => _RefillPageScreenState();
}

class _RefillPageScreenState extends State<RefillPageScreen> {
  final List<Map<String, dynamic>> medicationsRefill = [
    {
      'id': '1',
      'name': 'Lisinopril',
      'dosage': '10mg',
      'refillDate': '2026-04-10T00:00:00Z',
    }
  ];

  late Map<String, dynamic> selectedMed;
  int quantity = 30;
  String deliveryDate = '2026-03-26';

  @override
  void initState() {
    super.initState();
    selectedMed = medicationsRefill[0];
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
              // Medication Selection
              const Text(
                'Select Medication',
                style: TextStyle(
                  color: Color(0xFFA0622A),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              ...medicationsRefill.map((med) {
                final isSelected = selectedMed['id'] == med['id'];
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
                          '${med['name']} ${med['dosage']}',
                          style: const TextStyle(
                            color: Color(0xFF3B1F0A),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Current refill due: ${_formatDate(med['refillDate'])}',
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

              // Quantity
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

              // Delivery Date placeholder (TextField)
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
              const SizedBox(height: 20),

              // Prescription Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prescription on file',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your previous prescription from Dr. Emily Martinez is valid for this refill.',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Delivery Address
              const Text(
                'Delivery Address',
                style: TextStyle(
                  color: Color(0xFFA0622A),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF6EC),
                  border: Border.all(color: const Color(0xFFEFE2CC)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Home',
                      style: TextStyle(
                        color: Color(0xFF3B1F0A),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '123 Main Street, Apt 4B\nNew York, NY 10001',
                      style: TextStyle(
                        color: Color(0xFF6B3A1F),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Price Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF6EC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Medication', style: TextStyle(color: Color(0xFF6B3A1F), fontSize: 13)),
                        Text('\$25.99', style: TextStyle(color: Color(0xFF3B1F0A), fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery', style: TextStyle(color: Color(0xFF6B3A1F), fontSize: 13)),
                        Text('\$4.99', style: TextStyle(color: Color(0xFF3B1F0A), fontSize: 14)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFFEFE2CC), height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: TextStyle(color: Color(0xFF3B1F0A), fontSize: 15, fontWeight: FontWeight.w500)),
                        Text('\$30.98', style: TextStyle(color: Color(0xFF3B1F0A), fontSize: 18, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Bottom Bar
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Refill order placed successfully!'))
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B1F0A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Confirm Refill Order', style: TextStyle(color: Color(0xFFFBF6EC), fontSize: 15)),
              ),
            ),
          )
        ],
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
