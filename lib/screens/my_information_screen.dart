import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class MyInformationScreen extends StatefulWidget {
  const MyInformationScreen({super.key});

  @override
  State<MyInformationScreen> createState() => _MyInformationScreenState();
}

class _MyInformationScreenState extends State<MyInformationScreen> {
  final _nameController = TextEditingController(text: 'Charan');
  final _ageController = TextEditingController(text: '28');
  String _bloodGroup = 'O+';
  String _gender = 'Male';
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _emailController = TextEditingController(text: 'charan@example.com');
  final _emergencyController = TextEditingController(text: '+91 98765 99999');

  final List<String> _conditions = ['Hypertension', 'Asthma'];
  bool _showAddCondition = false;
  final _newConditionController = TextEditingController();

  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _genders = ['Male', 'Female', 'Other'];

  void _toggleCondition(String condition) {
    setState(() {
      if (_conditions.contains(condition)) {
        _conditions.remove(condition);
      } else {
        _conditions.add(condition);
      }
    });
  }

  void _addNewCondition() {
    final text = _newConditionController.text.trim();
    if (text.isNotEmpty && !_conditions.contains(text)) {
      setState(() {
        _conditions.add(text);
      });
    }
    setState(() {
      _newConditionController.clear();
      _showAddCondition = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _emergencyController.dispose();
    _newConditionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [AppColors.brownDeep, AppColors.brownMid],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: 56,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'My Information',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Full Name'),
                      _buildTextField(_nameController),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Age'),
                                _buildTextField(_ageController, keyboardType: TextInputType.number),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Blood Group'),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFBF6EC),
                                    border: Border.all(color: const Color(0xFFEFE2CC)),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  height: 48, // matching textfield height roughly
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _bloodGroup,
                                      isExpanded: true,
                                      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF3B1F0A)),
                                      items: _bloodGroups.map((bg) => DropdownMenuItem(value: bg, child: Text(bg, style: const TextStyle(color: Color(0xFF3B1F0A), fontSize: 14)))).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _bloodGroup = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      _buildLabel('Gender'),
                      Row(
                        children: _genders.map((g) {
                          final isSelected = _gender == g;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: g == _genders.last ? 0 : 8),
                              child: GestureDetector(
                                onTap: () => setState(() => _gender = g),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFD4822A) : const Color(0xFFFBF6EC),
                                    border: Border.all(color: isSelected ? const Color(0xFFD4822A) : const Color(0xFFEFE2CC)),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    g,
                                    style: TextStyle(
                                      color: isSelected ? const Color(0xFFFFFDF8) : const Color(0xFF6B3A1F),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),
                      _buildLabel('Phone Number'),
                      _buildTextField(_phoneController, keyboardType: TextInputType.phone),

                      const SizedBox(height: 16),
                      _buildLabel('Email'),
                      _buildTextField(_emailController, keyboardType: TextInputType.emailAddress),

                      const SizedBox(height: 16),
                      _buildLabel('Emergency Contact'),
                      _buildTextField(_emergencyController, keyboardType: TextInputType.phone),

                      const SizedBox(height: 16),
                      _buildLabel('Chronic Conditions'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ..._conditions.map((condition) => _buildConditionChip(condition)),
                          if (_showAddCondition)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFE2CC),
                                border: Border.all(color: const Color(0xFFD4822A), width: 2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: TextField(
                                      controller: _newConditionController,
                                      autofocus: true,
                                      style: const TextStyle(fontSize: 13, color: Color(0xFF3B1F0A)),
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                        hintText: 'New',
                                        hintStyle: TextStyle(color: Colors.black26),
                                      ),
                                      onSubmitted: (_) => _addNewCondition(),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: _addNewCondition,
                                    child: const Icon(Icons.add, size: 16, color: Color(0xFF6B3A1F)),
                                  ),
                                ],
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: () => setState(() => _showAddCondition = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFE2CC),
                                  border: Border.all(color: const Color(0xFFD4822A), width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add, size: 16, color: Color(0xFF6B3A1F)),
                                    SizedBox(width: 4),
                                    Text(
                                      'Add New',
                                      style: TextStyle(color: Color(0xFF6B3A1F), fontSize: 13, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
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
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Save Changes Logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Changes Saved!'), backgroundColor: Colors.green),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B1F0A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Save Changes', style: TextStyle(color: Color(0xFFFBF6EC), fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFFA0622A), fontSize: 13),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFF3B1F0A), fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFBF6EC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEFE2CC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD4822A)),
        ),
      ),
    );
  }

  Widget _buildConditionChip(String condition) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFE2CC),
        border: Border.all(color: const Color(0xFFD4822A), width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            condition,
            style: const TextStyle(color: Color(0xFF6B3A1F), fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _toggleCondition(condition),
            child: const Icon(Icons.close, size: 14, color: Color(0xFF6B3A1F)),
          ),
        ],
      ),
    );
  }
}
