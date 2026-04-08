import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/session_store.dart';

class MyInformationScreen extends StatefulWidget {
  const MyInformationScreen({super.key});

  @override
  State<MyInformationScreen> createState() => _MyInformationScreenState();
}

class _MyInformationScreenState extends State<MyInformationScreen> {
  final _nameController = TextEditingController(text: 'Sarah Johnson');
  final _ageController = TextEditingController(text: '32');
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController(text: 'sarah.johnson@email.com');
  final _emergencyController = TextEditingController(text: '+1 234 567 8901');

  String _selectedGender = 'Female';
  String? _selectedBloodGroup = 'O+';
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final Set<String> _conditions = {'Diabetes Type 2', 'Hypertension'};

  @override
  void initState() {
    super.initState();
    _phoneController.text = SessionStore.phoneNumber;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'My Information',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [AppColors.brownDeep, AppColors.brownMid],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _FieldLabel('Full Name'),
              const SizedBox(height: 8),
              _InputField(controller: _nameController),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('Age'),
                        const SizedBox(height: 8),
                        _InputField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('Blood Group'),
                        const SizedBox(height: 8),
                        _BloodGroupField(
                          value: _selectedBloodGroup,
                          items: _bloodGroups,
                          onChanged: (value) => setState(() => _selectedBloodGroup = value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _FieldLabel('Gender'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _GenderButton(
                    label: 'Male',
                    selected: _selectedGender == 'Male',
                    onTap: () => setState(() => _selectedGender = 'Male'),
                  ),
                  const SizedBox(width: 8),
                  _GenderButton(
                    label: 'Female',
                    selected: _selectedGender == 'Female',
                    onTap: () => setState(() => _selectedGender = 'Female'),
                  ),
                  const SizedBox(width: 8),
                  _GenderButton(
                    label: 'Other',
                    selected: _selectedGender == 'Other',
                    onTap: () => setState(() => _selectedGender = 'Other'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _FieldLabel('Phone Number'),
              const SizedBox(height: 8),
              _InputField(controller: _phoneController, keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              const _FieldLabel('Email'),
              const SizedBox(height: 8),
              _InputField(controller: _emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              const _FieldLabel('Emergency Contact'),
              const SizedBox(height: 8),
              _InputField(controller: _emergencyController, keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              const _FieldLabel('Chronic Conditions'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _conditions
                    .map(
                      (condition) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.accent),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              condition,
                              style: const TextStyle(
                                color: AppColors.brownLight,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.close,
                              size: 14,
                              color: AppColors.brownLight,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brownDeep,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.brownLight,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.cream,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.surface),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.surface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
    );
  }
}

class _BloodGroupField extends StatelessWidget {
  const _BloodGroupField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surface),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.brownMid),
          onChanged: onChanged,
          items: items
              .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
              .toList(),
        ),
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : AppColors.cream,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppColors.accent : AppColors.surface),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.brownLight,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
