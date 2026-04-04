import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'doctor_profile_screen.dart';

// ─── Data model ──────────────────────────────────────────────────────────────

class _HospitalData {
  const _HospitalData({
    required this.name,
    required this.city, // Instead of full address, React has city in cover
    required this.address,
    required this.timings,
    required this.verified,
    required this.specialties,
    required this.doctors,
  });

  final String name;
  final String city;
  final String address;
  final String timings;
  final bool verified;
  final List<String> specialties;
  final List<_DoctorData> doctors;
}

class _DoctorData {
  const _DoctorData({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.totalPatients,
    required this.fee,
  });

  final String id;
  final String name;
  final String specialty;
  final int experience;
  final int totalPatients;
  final int fee;
}

// ─── Static data ─────────────────────────────────────────────────────────────

const _hospitals = [
  _HospitalData(
    name: 'City General Hospital',
    city: 'New York',
    address: '123 Main Street, New York, NY 10001',
    timings: '24/7 Emergency',
    verified: true,
    specialties: ['Cardiology', 'Orthopedics', 'Neurology'],
    doctors: [
      _DoctorData(
        id: 'd1',
        name: 'Dr. Emily Martinez',
        specialty: 'Cardiologist',
        experience: 15,
        totalPatients: 1200,
        fee: 150,
      ),
      _DoctorData(
        id: 'd2',
        name: 'Dr. Michael Brown',
        specialty: 'Orthopedist',
        experience: 18,
        totalPatients: 750,
        fee: 200,
      ),
      _DoctorData(
        id: 'd3',
        name: 'Dr. Priya Patel',
        specialty: 'Neurologist',
        experience: 14,
        totalPatients: 890,
        fee: 220,
      ),
    ],
  ),
  _HospitalData(
    name: 'Metro Health Center',
    city: 'New York',
    address: '456 Oak Avenue, New York, NY 10002',
    timings: '8:00 AM - 10:00 PM',
    verified: true,
    specialties: ['Endocrinology', 'Pediatrics', 'Dermatology'],
    doctors: [
      _DoctorData(
        id: 'd4',
        name: 'Dr. James Wilson',
        specialty: 'Endocrinologist',
        experience: 12,
        totalPatients: 950,
        fee: 180,
      ),
    ],
  ),
  _HospitalData(
    name: 'Sunrise Medical',
    city: 'Los Angeles',
    address: '789 Broadway, Los Angeles, CA 90015',
    timings: '7:00 AM - 9:00 PM',
    verified: true,
    specialties: ['General Medicine', 'Surgery', 'Radiology'],
    doctors: [
      _DoctorData(
        id: 'd5',
        name: 'Dr. Sarah Chen',
        specialty: 'General Physician',
        experience: 8,
        totalPatients: 1500,
        fee: 100,
      ),
    ],
  ),
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
      backgroundColor: const Color(0xFFFFFDF8),
      body: Column(
        children: [
          // ─── Brown Header ──────────────────────────────────────────────
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
                    Center(
                      child: Text(
                        hospital.name,
                        style: const TextStyle(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Cover Photo ───────────────────────────────────────────────
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF3B1F0A),
                          Color(0xFF6B3A1F),
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Decorative circles matching React design opacity-10
                        Opacity(
                          opacity: 0.1,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 16,
                                left: 32,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                right: 32,
                                child: Container(
                                  width: 128,
                                  height: 128,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 32,
                                right: 64,
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Content
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(Icons.domain, color: Color(0xFFFBF6EC), size: 28),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              hospital.city,
                              style: TextStyle(
                                color: const Color(0xFFFBF6EC).withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ─── Content Padding ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── Header Info ───────────────────────────────────────
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          children: [
                            Text(
                              hospital.name,
                              style: const TextStyle(
                                color: Color(0xFF3B1F0A),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Playfair Display',
                              ),
                            ),
                            if (hospital.verified)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4822A).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.workspace_premium, color: Color(0xFFD4822A), size: 12),
                                    SizedBox(width: 4),
                                    Text(
                                      'VITADATA Verified',
                                      style: TextStyle(
                                        color: Color(0xFFD4822A),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(Icons.location_on_outlined, color: Color(0xFFA0622A), size: 16),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                hospital.address,
                                style: const TextStyle(
                                  color: Color(0xFF6B3A1F),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined, color: Color(0xFFA0622A), size: 16),
                            const SizedBox(width: 8),
                            Text(
                              hospital.timings,
                              style: const TextStyle(
                                color: Color(0xFF6B3A1F),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ─── Specialties ───────────────────────────────────────
                        const Text(
                          'Specialties',
                          style: TextStyle(
                            color: Color(0xFF3B1F0A),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: hospital.specialties.map((s) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBF6EC),
                                border: Border.all(color: const Color(0xFFEFE2CC)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                s,
                                style: const TextStyle(
                                  color: Color(0xFF6B3A1F),
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 24),

                        // ─── Medical Staff ─────────────────────────────────────
                        Text(
                          'Medical Staff (${hospital.doctors.length})',
                          style: const TextStyle(
                            color: Color(0xFF3B1F0A),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (hospital.doctors.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBF6EC),
                              border: Border.all(color: const Color(0xFFEFE2CC)),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.people_outline, color: Color(0xFFEFE2CC), size: 32),
                                SizedBox(height: 8),
                                Text(
                                  'No doctors listed yet',
                                  style: TextStyle(
                                    color: Color(0xFFA0622A),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: hospital.doctors.map((doc) => _DoctorCard(doctor: doc)).toList(),
                          ),
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


// ─── Doctor Card ─────────────────────────────────────────────────────────────

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.doctor});

  final _DoctorData doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF6EC),
        border: Border.all(color: const Color(0xFFEFE2CC)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
                // navigate to doctor if needed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorProfileScreen(
                  id: doctor.id,
                  name: doctor.name,
                  specialty: doctor.specialty,
                  hospital: 'City General Hospital', // default mock 
                  experience: doctor.experience,
                  totalPatients: doctor.totalPatients,
                  fee: doctor.fee,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Top row: Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFD4822A),
                            Color(0xFFA0622A),
                          ],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        doctor.name.startsWith('Dr. ') && doctor.name.length > 4 
                            ? doctor.name[4] 
                            : (doctor.name.isNotEmpty ? doctor.name[0] : 'D'),
                        style: const TextStyle(
                          color: Color(0xFFFBF6EC),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Playfair Display',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.name,
                            style: const TextStyle(
                              color: Color(0xFF3B1F0A),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Playfair Display',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            doctor.specialty,
                            style: const TextStyle(
                              color: Color(0xFF6B3A1F),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              Text(
                                '${doctor.experience}y Experience',
                                style: const TextStyle(
                                  color: Color(0xFFA0622A),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${doctor.totalPatients}+ Patients',
                                style: const TextStyle(
                                  color: Color(0xFFA0622A),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Price & arrow
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${doctor.fee}',
                          style: const TextStyle(
                            color: Color(0xFFD4822A),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3B1F0A),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFFFBF6EC),
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFEFE2CC), height: 1),
                const SizedBox(height: 12),
                // Bottom row: Schedule
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green, // matches green-500
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Available Mon–Fri, 9AM–6PM',
                          style: TextStyle(
                            color: Color(0xFF6B3A1F),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4822A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.calendar_month, color: Color(0xFFD4822A), size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Schedule',
                            style: TextStyle(
                              color: Color(0xFFD4822A),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
