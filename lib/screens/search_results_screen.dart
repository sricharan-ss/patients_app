import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _controller = TextEditingController();

  static const _hospitals = [
    'City General Hospital',
    'Metro Health Center',
    'Sunrise Medical',
    'Wellness Clinic',
  ];

  static const _doctors = [
    'Dr. Emily Martinez',
    'Dr. Sarah Chen',
    'Dr. Michael Brown',
    'Dr. Aisha Khan',
    'Dr. Rajesh Nair',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim().toLowerCase();
    final filteredHospitals = _hospitals
        .where((h) => query.isEmpty || h.toLowerCase().contains(query))
        .toList();
    final filteredDoctors = _doctors
        .where((d) => query.isEmpty || d.toLowerCase().contains(query))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.warmWhite,
        title: const Text(
          'Search',
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          children: [
            TextField(
              controller: _controller,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search doctors, hospitals...',
                hintStyle: const TextStyle(color: Color(0xFFB69A83)),
                prefixIcon: const Icon(Icons.search, color: AppColors.brownMid),
                filled: true,
                fillColor: AppColors.cream,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  borderSide: const BorderSide(color: AppColors.accent, width: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const _ResultHeader(title: 'Hospitals'),
            const SizedBox(height: 8),
            ...filteredHospitals.map((h) => _ResultTile(title: h, icon: Icons.local_hospital_outlined)),
            const SizedBox(height: 14),
            const _ResultHeader(title: 'Doctors'),
            const SizedBox(height: 8),
            ...filteredDoctors.map((d) => _ResultTile(title: d, icon: Icons.person_outline)),
            if (filteredHospitals.isEmpty && filteredDoctors.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(
                      color: AppColors.brownMid,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.brownDeep,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surface),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.brownMid, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.brownDeep,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.brownLight, size: 20),
          ],
        ),
      ),
    );
  }
}
