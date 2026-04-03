import 'package:flutter/material.dart';
import '../core/app_colors.dart';

// ─── Data model ──────────────────────────────────────────────────────────────

class _HospitalData {
  const _HospitalData({
    required this.name,
    required this.address,
    required this.timings,
    required this.rating,
    required this.reviewCount,
    required this.specialties,
    required this.doctors,
  });

  final String name;
  final String address;
  final String timings;
  final String rating;
  final String reviewCount;
  final List<String> specialties;
  final List<_DoctorData> doctors;
}

class _DoctorData {
  const _DoctorData({
    required this.name,
    required this.specialty,
    required this.rating,
  });

  final String name;
  final String specialty;
  final String rating;
}

// ─── Static data (mirrors hospital_list_screen + doctor_list_screen) ─────────

const _hospitals = [
  _HospitalData(
    name: 'City General Hospital',
    address: '123 Main Street, New York, NY 10001',
    timings: '24/7 Emergency',
    rating: '4.5',
    reviewCount: '856',
    specialties: ['Cardiology', 'Orthopedics', 'Neurology'],
    doctors: [
      _DoctorData(name: 'Dr. Emily Martinez', specialty: 'Cardiologist', rating: '4.8'),
      _DoctorData(name: 'Dr. Rajesh Nair', specialty: 'Neurologist', rating: '4.5'),
    ],
  ),
  _HospitalData(
    name: 'Metro Health Center',
    address: '456 Oak Avenue, New York, NY 10002',
    timings: '8:00 AM - 10:00 PM',
    rating: '4.7',
    reviewCount: '612',
    specialties: ['Endocrinology', 'Pediatrics', 'Dermatology'],
    doctors: [
      _DoctorData(name: 'Dr. Michael Brown', specialty: 'Orthopedist', rating: '4.6'),
      _DoctorData(name: 'Dr. James Wilson', specialty: 'Endocrinologist', rating: '4.9'),
    ],
  ),
  _HospitalData(
    name: 'Sunrise Medical',
    address: '789 Broadway, New York, NY 10003',
    timings: '7:00 AM - 9:00 PM',
    rating: '4.6',
    reviewCount: '493',
    specialties: ['General Medicine', 'Surgery', 'Radiology'],
    doctors: [
      _DoctorData(name: 'Dr. Sarah Chen', specialty: 'General Physician', rating: '4.7'),
      _DoctorData(name: 'Dr. Kevin Park', specialty: 'Surgeon', rating: '4.5'),
    ],
  ),
  _HospitalData(
    name: 'Wellness Clinic',
    address: '321 Park Avenue, New York, NY 10004',
    timings: '9:00 AM - 7:00 PM',
    rating: '4.4',
    reviewCount: '287',
    specialties: ['Family Medicine', 'Psychiatry'],
    doctors: [
      _DoctorData(name: 'Dr. Aisha Khan', specialty: 'Dermatologist', rating: '4.7'),
      _DoctorData(name: 'Dr. Priya Sharma', specialty: 'Psychiatrist', rating: '4.3'),
    ],
  ),
];

const _reviews = [
  (name: 'John Smith', rating: 5, comment: 'Excellent service and very professional staff.'),
  (name: 'Emma Davis', rating: 4, comment: 'Great facility, clean and well-maintained.'),
  (name: 'Michael Chen', rating: 5, comment: 'The doctors are highly skilled and caring.'),
];

// ─── Screen ──────────────────────────────────────────────────────────────────

class HospitalDetailScreen extends StatelessWidget {
  const HospitalDetailScreen({super.key, required this.hospitalName});

  final String hospitalName;

  static _HospitalData _findHospital(String name) {
    return _hospitals.firstWhere(
      (h) => h.name == name,
      orElse: () => _hospitals.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hospital = _findHospital(hospitalName);

    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: Column(
        children: [
          // ── Brown header ──────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [AppColors.brownDeep, AppColors.brownMid],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.warmWhite, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      hospital.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.warmWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // Mirror of back button for centering
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          // ── Scrollable content ────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover photo placeholder
                  Container(
                    width: double.infinity,
                    height: 180,
                    color: const Color(0xFFF7EFDF),
                    child: const Center(
                      child: Icon(
                        Icons.domain_rounded,
                        color: Color(0xFFEFE2CC),
                        size: 72,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Rating row ────────────────────────────────
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.accent, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              hospital.rating,
                              style: const TextStyle(
                                color: AppColors.brownDeep,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(${hospital.reviewCount} reviews)',
                              style: const TextStyle(
                                color: AppColors.brownLight,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'VITADATA Verified',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ── Address ───────────────────────────────────
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(Icons.location_on_outlined, color: AppColors.brownLight, size: 16),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                hospital.address,
                                style: const TextStyle(
                                  color: AppColors.brownMid,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // ── Timings ───────────────────────────────────
                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined, color: AppColors.brownLight, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              hospital.timings,
                              style: const TextStyle(
                                color: AppColors.brownMid,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ── Specialties ───────────────────────────────
                        const Text(
                          'Specialties',
                          style: TextStyle(
                            color: AppColors.brownDeep,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: hospital.specialties
                              .map(
                                (s) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.cream,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.surface),
                                  ),
                                  child: Text(
                                    s,
                                    style: const TextStyle(
                                      color: AppColors.brownMid,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 22),

                        // ── Reviews ───────────────────────────────────
                        const Text(
                          'Reviews',
                          style: TextStyle(
                            color: AppColors.brownDeep,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: _reviews
                              .map(
                                (r) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.cream,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: AppColors.surface),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              r.name,
                                              style: const TextStyle(
                                                color: AppColors.brownDeep,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              children: List.generate(
                                                r.rating,
                                                (_) => const Icon(Icons.star, color: AppColors.accent, size: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          r.comment,
                                          style: const TextStyle(
                                            color: AppColors.brownMid,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 10),

                        // ── Doctors ───────────────────────────────────
                        const Text(
                          'Doctors at this hospital',
                          style: TextStyle(
                            color: AppColors.brownDeep,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 160,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: hospital.doctors.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, i) {
                              final doc = hospital.doctors[i];
                              return _DoctorCard(doctor: doc);
                            },
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Doctor card (horizontal list) ───────────────────────────────────────────

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.doctor});

  final _DoctorData doctor;

  String _initials(String name) {
    return name
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase())
        .take(2)
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surface),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _initials(doctor.name),
              style: const TextStyle(
                color: AppColors.cream,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            doctor.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.brownDeep,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            doctor.specialty,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.brownLight,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: AppColors.accent, size: 11),
              const SizedBox(width: 3),
              Text(
                doctor.rating,
                style: const TextStyle(
                  color: AppColors.brownDeep,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
