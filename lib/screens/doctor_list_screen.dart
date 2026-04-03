import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({super.key});

  static const _doctors = [
    (
      name: 'Dr. Emily Martinez',
      specialty: 'Cardiologist',
      hospital: 'City General Hospital',
      rating: '4.8',
      reviews: '245 reviews',
      patients: '1200+ patients',
      aiPick: true,
    ),
    (
      name: 'Dr. Sarah Chen',
      specialty: 'General Physician',
      hospital: 'Sunrise Medical',
      rating: '4.7',
      reviews: '312 reviews',
      patients: '1500+ patients',
      aiPick: true,
    ),
    (
      name: 'Dr. Michael Brown',
      specialty: 'Orthopedist',
      hospital: 'Metro Health Center',
      rating: '4.6',
      reviews: '201 reviews',
      patients: '980+ patients',
      aiPick: false,
    ),
    (
      name: 'Dr. Aisha Khan',
      specialty: 'Dermatologist',
      hospital: 'Wellness Clinic',
      rating: '4.7',
      reviews: '187 reviews',
      patients: '890+ patients',
      aiPick: false,
    ),
    (
      name: 'Dr. Rajesh Nair',
      specialty: 'Neurologist',
      hospital: 'City General Hospital',
      rating: '4.5',
      reviews: '166 reviews',
      patients: '760+ patients',
      aiPick: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.warmWhite,
        title: const Text(
          'Doctors',
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
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
          children: [
            const Text(
              'Based on your medical history and preferences,\nwe recommend these doctors:',
              style: TextStyle(
                color: AppColors.brownLight,
                fontSize: 19,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surface),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Row(
                children: [
                  Icon(Icons.search, color: AppColors.brownMid, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Search doctors...',
                    style: TextStyle(
                      color: Color(0xFFB69A83),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ..._doctors.map(
              (d) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _DoctorCard(
                  name: d.name,
                  specialty: d.specialty,
                  hospital: d.hospital,
                  rating: d.rating,
                  reviews: d.reviews,
                  patients: d.patients,
                  aiPick: d.aiPick,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.reviews,
    required this.patients,
    required this.aiPick,
  });

  final String name;
  final String specialty;
  final String hospital;
  final String rating;
  final String reviews;
  final String patients;
  final bool aiPick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surface),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: AppColors.brownDeep,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (aiPick)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1E7FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          '✦ AI Pick',
                          style: TextStyle(
                            color: Color(0xFF8F3AF8),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  specialty,
                  style: const TextStyle(
                    color: AppColors.brownDeep,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hospital,
                  style: const TextStyle(
                    color: AppColors.brownLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.accent, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      rating,
                      style: const TextStyle(
                        color: AppColors.brownDeep,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      reviews,
                      style: const TextStyle(
                        color: AppColors.brownLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        patients,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.brownLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
